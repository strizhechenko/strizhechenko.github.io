---
title: Снижение нагрузки на Nginx со статичной статикой
---

Представьте, у вас есть nginx, в задачи которого вообще не входит _никакой_ динамики - всё что нужно - отдавать одни и те же файлы, возможно даже одну и ту же страницу на _любой_ запрос. А запросов много, а ответить хочется всем, да ещё и без 502 ошибок. И, допустим, сейчас nginx выедает 75% процессорного времени (а остальные 25% выедает та же самая нагрузка, но приходится она на ядро ОС). Что можно сделать?

## Снижаем нагрузку с SSL

### Если терминируется SSL, использовать SSL-сертификаты на эллиптических кривых

Приведу минималистичный пример изготовления самоподписных сертфикатов. По-хорошему ecc.key вы оставляете у себя, ecc.req заполняете нормально и отправляете в удостоверяющий центр, который вам его подпишет своим закрытым ключом и выдаст публичный ключ. Но на практике так бывает не всегда. Суть в разрезе статьи именно в использовании эллиптических кривых, а не RSA.

``` shell
# Создаём приватный ключ
openssl ecparam -out ecc.key -name prime256v1 -genkey
# Генерируем запрос подписи, если непонятно зачем - так надо
openssl req -new -key ecc.key -out ecc.req -subj "/C=RU/"
# Подписываем этот запрос.. сами, тем же ключом (sic!) и получаем публичный ключ
openssl req -x509 -nodes -days 365 -key ecc.key -in ecc.req -out ecc.crt
# Избавляемся от запроса, он нам больше не нужен
rm -vf ecc.req
```

Одно это уже позволит снизить нагрузку от терминации множества SSL-соединений в 2-3 раза.

### Обрезаем `ssl_ciphers`

Это лучше делать очень аккуратно и наблюдая за клиентами, т.к. отсутствие совместимых шифров приведёт к недоступности сервера. В общем случае можно отсечь RSA (если перешли на эллиптические кривые) и `+LOW:+SSLv2`. Зачем? Снизить размер ServerHello (шутка).

## Снижаем нагрузку от дискового I/O

### Используем файловый кэш для статики

Моей интерпретации опций верить не надо, верить надо документации nginx.

``` toml
# Во-первых избеагем дискового I/O.
# max - после какого числа использований всё же инвалидируем кэш и перечитываем файл
# inactive - см. open_file_cache_min_uses
open_file_cache max=1000000 inactive=60s;
# И даже stat на него не делаем лишний раз (чаще 65 сек), проверяя изменился ли он
open_file_cache_valid 65s;
# Если за inactive 60 сек файл не был использован хотя бы 2 раза, тоже инвалидируем кэш.
open_file_cache_min_uses 2;
# И 404 ошибки тоже кэшируем (если такое бывает). Всё кэшируем. Даже небо, даже, ну вы поняли.
open_file_cache_errors on
```

### Агрессивно избегаем поиска файлов на диске, если лучше знаем что нужно пользователю

Тупо игнорируем `$uri`, запрошенный клиентом и на _любые_ запросы отдаём нашу статическую страничку.

``` toml
try_files /index.html /index.html;
```

Но если какие-то другие файлы помимо index.html существуют, но на все неизвестные URL надо отдавать эту страничку, то делаем так:

``` toml
try_files $uri /index.html;
error_page 404 = /index.html;
```

Если даже на битые запросы нужно отдавать эту страничку, то добавляем

``` toml
error_page 400 = /index.html;
```

Стоит подумать, как при запросах `hostname/something/` избегать отправки редиректа на `hostname/something`. Минус -1 RTT, -1 запрос, быстрее закроется TCP-соединение, быстрее пропадёт из conntrack.

### Отключение логирования

_Очень_ внимательно подумайте перед этим шагом. Делайте это только если вы вообще всё уже отладили и вам на эти запросы глубоко пофигу.

## Настраиваем сам nginx

Устанавливаем приемлемое количество обработчиков. Если сервер _очень_ многоядерный, а вы хотите ограничить нагрузку, создаваемую веб-сервером, лучше избегать `worker_process = auto` и явно обозначить свои ожидания.

В моём случае при 4+ ядрах имело смысл остановиться на 4 процессах, в случае если ядер меньше - использовать не меньше 2 процессов.

### Выравнивание нагрузки

Задача-максимум - каким ядром процессора принятый пакет копировался (и распределение для копирования должно быть равномерным!), тем же должен и обработаться, на том же ядре должен находиться и рабочий процесс nginx, который будет обрабатывать запрос в пакете. Так можно получить идеальное использование процессорных кэшей.

Задача минимум - если распределение запросов _относительно_ равномерное _и_ при этом другой нагрузки на физической машине нет - можно убить демон irqbalance, чтобы не перемещал процессы между ядрами. Создать по одному рабочему процессу на каждое ядро и в процессе/после старта строго привязать их к ядрам. Однако, если поток запросов из ядра ОС прилетает с сильными перекосами - это не принесёт пользы и даже навредит.

### Число обслуживаемых соединений

Увеличиваем потолок раза в 4 от стандартного, в случае если упираемся в число открытых файловых дескрипторов.

``` toml
worker_connections 4096;
```

Параллельно анализируем поведение клиентов. Если соединения _не_ переиспользуются, а в топе распределения статусов conntrack висят `TIME_WAIT`, имеет смысл заняться аккуратным зарезанием этих таймаутов параметрами ОС. В неадекватные значения типа 1 секунды уходить не надо, но снижение на дефолтных значений на 30-60% может сильно облегчить жизнь серверу. Опять же - это актуально только для множества коротких разовых запросов от разных клиентов. Если профиль нагрузки выглядит иначе, клиенты переиспользуют соединения, длинные `TIME_WAIT` могут быть уместны, поскольку спасут от постоянного пересоздания соединений.
