---
layout: page
title: Обо мне
permalink: /about/
---

## Контакты:

### Кодинг

- [codewars](https://www.codewars.com/users/strizhechenko)
- [github](https://github.com/strizhechenko)
- [linkedin](https://linkedin.com/in/strizhechenko)
- [habrahabr](http://habrahabr.ru/users/weirded)
- [блог о Linux и смежном](http://strizhechenko.github.io)

### Прочее
- [twitter (основной)](https://twitter.com/strizhechenko)
- [twitter (англоязычный)](https://twitter.com/acid_code)
- [twitter о книгах](https://twitter.com/acid_books)
- [twitter о фильмах](https://twitter.com/acid_movies)
- [bandcamp (acid house)](https://genacid.bandcamp.com)
- [soundcloud (acid house)](https://soundcloud.com/genacid)
- [soundcloud (random)](https://soundcloud.com/weirded)
- [last.fm](https://last.fm/user/panzersoldat)
- [vkontakte](https://vk.com/weirded)
- [instagram](https://instagram.com/weirdedout)
- [почта](mailto:oleg.strizhechenko+random@gmail.com)

## Языки программирования и навыки

### Основные

#### bash
- замечательная вещь, если скрипт влезает на экран и не содержит функций
- в своё время доходил до невыразимых безумий с eval и unit-тестированием, больше не хочу
- написал [свой собственный гайд по разработке на bash](https://gist.github.com/strizhechenko/f82b6eeb29187bdb7e99d6baf46665ab)
- toolchain: vim > atom, bash -eux, shellcheck

#### python

- tweepy - люблю писать твиттерботов, удобная либа. мой враппер поверх неё: [https://github.com/strizhechenko/twitterbot_utils](https://github.com/strizhechenko/twitterbot_utils)
- pymorphy2 - люблю генерировать русскоязычные тексты, а эта либа отлично склоняет слова
- flask - когда мне приходится делать что-то смотрящее в веб - обычно использую его для минимизации боли. Например вот сделал себе одностраничник, чтобы смотреть как далеко нужные мне троллейбусы от часто используемых мной остановок: [bus.acidkernel.com](http://bus.acidkernel.com) ([github](http://github.com/strizhechenko/trolleybuses))
- flask-api - полюбил, когда делал прослойку между postgres и сборщиком метрик для influxdb.
- qdns / dnspython - писал многопоточный резолвер с кэшем + своеобразный gethostbyname, возвращающий список ответов всех серверов
- toolchain: vim > atom > PyCharm CE, nosetests, pylint, ipython, cProfile
- parsers: xml.etree for quick coding, xml.sax for fast processing, json for APIs, sometimes sed/grep/awk for invalid HTML :D.

#### c

- linux kernel, netfilter, iptables - в основном пилил модули ядра для фильтрации трафика (производительные MitM для HTTP, HTTPS и DNS с поддержкой IPv6).
- pf_ring - потратил около 4 часов на эксперименты, а потом обломался из-за отсутствия стенда для тестов
- netflow processing - портировал с 32 на 64бит один legacy-проект по сбору и агрегации статистики
- toolchain: vim > atom, cmocka, gcc/clang, clang-format, clang-check, gdb, strace, gprof, make

#### linux

- очень хорошо разбираюсь в настройках для производительности сетевых карт (RPS, RRS, Coalesce/Buffer size итд).
- хорошо разбираюсь в современных утилитках для траблшутинга (в основном сетевые и производительность): iproute2, ethtool, ss, procps, bind-utils, top, iotop, oprofile, ftrace

#### sql/postgres

Недавно (май 2016), поддавшись влиянию @backendsecret из твиттера, решил пощупать возможности postgres по работе с json и проклял всё, но в итоге всё же смог им воспользоваться и получил некоторый профит. Хоррор по началу был в разборе кучи данных в markdown, который был собран кодом на bash, их парсингу на python, преобразованию в json и складыванию в jsonb-поля базы данных, откуда их можно было забрать практически в неизменном виде в виде тонкой прослойки в виде flask-api (он, кстати, няшный) и сложить в influxdb и затем любоваться графиками в grafana. Синтаксис запросов к json-полям - дичайшая боль, наверное единственный адекватный способ это делать - писать UDF на python. Но боль болью, а задачу свою postgres выполняет хорошо.

#### influxdb / grafana / метрики

Давно использую для сбора и визуализации данных, в основном связанных с бизнесом. Спихиваю туда много чего, от потенциальной зарплаты на текущий месяц в рублях/долларах/евро по текущему курсу и статистики числа обнаруженных системой самодиагностики проблем на серверах кастомеров, которые мы обслуживаем до скорости ответов нескольких наших сервисов и результаты прохождения тестов (данные беру от jenkins).

#### css
- metroui.org.ua - больше ничего никогда не использовал, в CSS могу еле-еле. Использовал его в [веб-интерфейсе Carbon Reductor](http://demo-reductor.carbonsoft.ru), [bus.acidkerne.com](http://bus.acidkernel.com).

#### Виртуализация

Активный пользователь, писал много всего связанного с автоматическим деплоем виртуалок/контейнеров для рабочих нужд, особое внимание уделял сложным сетевым схемам и роутингу между разными виртуалками/контейнерами. Немного занимался сетевой произволительностью в виртуальных (впрочем и физических тоже) машинах связанной с захватом и анализом трафика.

- openvz
- lxc
- kvm
- libvirt

#### Документация

Люблю писать человечную документацию, которую не надо читать полностью, чтобы решить проблему. Умею в rst и Markdown. Котирую wiki, например confluence. Пример: [документация Carbon Reductor](http://docs.carbonsoft.ru/display/reductor5). Умею в пресс-релизы с ещё более человечным описанием новых фишечек. Не умею в хорошее ведение ChangeLog.

### На уровне "поправить, не понимая как оно в целом работает, но добиться своего"

- c++
- java
- php
- javascript
- sql
- go

### Вещи которые хочу когда-нибудь поковырять поподробнее

Не решить 1-2 проблемы с помощью stackoverflow, а именно прочитать значительную часть документации.

- selinux
- graphite
- systemd
- netfilter современного ядра Linux
- ansible - люблю и часто использую, но возможно не идеально
- continuous queries в influxdb
- docker
- openstack
- write twitterbot with golang
- profiling and optimizing sql in postgres
- combining zabbix (as alerter) and influxdb
- tweepy twitter streaming api in twitterbot-utils
- python-midi (drums, other instruments, virtual midi controller, combine with garageband)
- gcov automation
- устройство Kbuild и dkms
- правильное использование pipelines в jenkins
- использование oprofile для профилирования приложений в пользовательском пространсте

## Книги

### Недочитанные
- Разные эссе Джорджа Оруэлла
- Мёртвые души
- Квантовая механика - теоретический минимум
- Site Reliability Engineering: How Google runs production software
- Selinux user guide

### Программирование
- Программист-прагматик
- An Introducion to programming on Go
- Мифический человекомесяц
- Верёвка достаточной длины чтобы выстрелить себе в ногу
- Язык программирования Си
- Азбука Ядра с примерами
- Факты и заблуждения профессиональого программирования
- Dive into python
- Чистый код
- Гибкие технологии экстремальное программирование и RUP
- Главный вопрос программирования, рефакторинга и всего такого
- Человеческий фактор. Успешные проекты и команды
- Scrum и XP заметки с передовой 2007г
- Экстремальное программирование 2002г
- Advanced Bash Scripting Guide
- Linux Advanced Routing and Traffic Control
- Iptables Tutorial 1.1.19
- Unix in a nutshell
- Искусство программирования для Unix

#### RHEL

- 7.0, 7.1, 7.2, 7.3 release notes
- getting started with containers

### Художественная литература

#### Берроуз
- Джанки
- Пидор

#### Джордж Оруэл
- 1984
- Скотный двор

#### Олдос Хаксли
- Дивный новый мир
- Двери восприятия

#### Эдвард Фостер
- Машина останавливается

#### Говард Лавкрафт
- Тень над Иннсмаутом
- Ужас Данвича
- Хребты безумия
- Зов Ктулху
- Дагон
- Склеп
- Полярис
- За стеной сна
- Проклятие города Сарнат
- Показания Рэндольфа Картера
- Белый корабль
- Артур Джермин
- Кошки Ультхара
- Храм
- Странный старик
- Дерево
- Лунное болото
- Музыка Эриха Цанна
- Безымянный город
- Другие боги
- Изгой
- Иранон
- Герберт Уэст - реаниматор
- Пёс
- Гипнос
- Затаившийся страх
- Праздник
- Крысы в стенах
- Неименуемое
- Узник фараонов
- Заброшенный дом
- Он
- Кошмар в Ред-Хуке
- В склепе
- Холод
- Фотография с натуры
- Серебряный ключ
- Загадочный дом на туманном утёсе
- Случай Чарльза Декстера Варда
- Сомнамбулический поиск неведомого Кадата
- Коты Ултара
- Ведьмин лог

#### Дэниел Киз
- Множественные умы Билли Миллигана
- Цветы для Элджернона

#### Джефф нун
- Автоматическая Алиса

### В очереди на чтение
- Божественная комедия
- Обитающий во тьме
- Единственный наследник
- Комната с заколоченными ставнями
- Крылатая смерть
- Локон медузы
- Ловушка
- Наследство Пибоди
- Модель для Пикмана
- Ночное братство
- Окно в мансарде
- Погребёный с фараонами (вероятно узник фараонов, это уже читал)
- Сны в ведьмином доме
- Тайна среднего пролёта
- Тень в мансарде
- Ужас в музее
- В стенах Эрикса
- Врата серебряного ключа
- За гранью времен
- Запертая комната
- Сны ужаса и смерти
- Сон
- Чужой
- Память
- Сияние извне
- Вне времени
- Алхимик
- Азатот
- День Уэнтворта
- Дерево на холме
- Грибы с юггота
- Хаос наступающий
- Из глубин мироздания
- Карающий рок над Сарнатом
- Картинка в старой книге
- Книга
- Лампа Адь-Хазреда
- Нечто в лунном свете
- Перевоплощение Хуана Ромеро
- Переживший человечество
- Пёс
- Потомок
- Пришелец из космоса
- Селефаис
- Слуховое окно
- Служитель зла
- Ужасы старого кладбища
- Возвращение к предкам
- Зеленый луг
- Зверь в подземелье

## Фильмы

[SVG](/images/movies.svg) [PNG](/images/movies.png)

### Нормальные
- 500 дней лета (2009)
- Безумный Макс (1979)
- Безумный Макс 2: Воин дороги (1981)
- Безумный Макс: Дорога ярости (2015)
- Большой Лебовски (1998)
- Бэтмен возвращается (1992)
- Бэтмен навсегда (1995)
- Бэтмен и робин (1997)
- В джазе только девушки (1959)
- Ван Хельсинг (2004)
- Властелин колец: Братство кольца (2001)
- Властелин колец: Возвращение Короля (2003)
- Властелин колец: Две крепости (2002)
- Внутри Льюина Дэвиса (2012)
- Вонг Фу, с благодарностью за всё! Джули Ньюмар (1995)
- Ворон (1994)
- Далласский клуб покупателей (2013)
- Драйв (2011)
- Другой мир (2003)
- Заводной апельсин (1971)
- Зов Ктулху (2005)
- Игры разума (2001)
- На игле (1996)
- Мир Юрского периода (2015)
- Оно (1990)
- Планета обезьян (1968)
- Привидение (1990)
- Сияние (1980)
- Страх (1983)
- Страх и ненависть в Лас-Вегасе (1998)
- Титаник
- Терминатор 2: Судный день
- Терминатор: Генезис (2015)
- Шепчущий во тьме (2011)
- Кэнди (2006)
- Не думай про белых обезъян
- Истории подземки
- Метропия
- Мэри и Макс (2009)
- Изгоняющий заново (1990)
- Унесённые призраками (2002)
- Варкрафт (2016)
- Матрица
- Матрица: перезагрузка
- Матрица: революция
- Отряд самоубийц (2016)
- Чудо на Гудзоне (2016)
- Доктор Стрендж (2016)
- Пароходный билл (1928)

### Ебанутые

#### Слегка
- Ангел Мщения (1981)
- Беспокойная Анна (2007)
- В финале Джон умрет (2012)
- Видеодром (1982)
- Горячие головы 2 (1993)
- Жидкое небо (1982)
- Зловещие мертвецы 3: Армия тьмы (1992)
- Клуб «Shortbus» (2006)
- Новые парни турбо (2010)
- Отвращение (1965)
- Панк из Солт-Лейк-Сити (1998)
- Робот (2010)
- Теорема Зеро (2013)
- Техносекс (2002)
- Я (2009)
- Пережить свою жизнь
- Реаниматор
- Невеста реаниматора
- Возвращение реаниматора
- Труп в белом саване дрожит, но продолжает принимать ванну
- Безумие (2005)

#### Совсем
- Бисер перед свиньями (1999)
- Декодер (1984)
- Догола (1999)
- Кислотный дом (1998)
- Малиновый рейх (2004)
- Отто, или В компании мертвецов (2008)
- Токсичный мститель (1984)
- Трудно быть Богом (2013)
- Тэцуо, железный человек (1989)
- Эдвард руки-пенисы (1991)
- Я киборг, но это нормально (2006)

### Охуенные
- Бэтмен (1966)
- Водный мир (1995)
- Всегда говори «ДА» (2008)
- Голубой утенок (2006)
- Доктор Стрейнджлав, или Как я научился не волноваться и полюбил атомную бомбу (1963)
- Дюна (1984)
- Зеленый сойлент (1973)
- Машина времени (2002)
- Нирвана (1997)
- Одинокий мужчина (2009)
- Растрать свою молодость (2003)
- Шоу ужасов Рокки Хоррора (1975)
- Сибилла (2007)
- Время Евы (2009)
- Трасса 60 (2002)
- Солярис (1972)
- Ex Machina (2014)
- Мальчик в полосатой пижаме (2008)
- Er ist wieder da (2014)
- Расплата (2016)

## Используемые ОС

### Сейчас

- Mac OS X 10.11
- iOS 9.3
- CentOS 6
- Windows 8.1
- Android 4.0
- Ubuntu 16.04

### В прошлом

- Ubuntu 10.04
- Ubuntu 12.04
- Fedora 16
- Mandriva 2007
- Debian 6
- Windows XP
- Windows 7
- Mac OS X 10.9 (господи, какой прекрасный был дизайн, но kernel panic при закрытии вкладок SSH доканали).
- CentOS 7

## Мои боты в твиттере
- [https://twitter.com/__coding_tips__](https://twitter.com/__coding_tips__)
- [https://twitter.com/coding_tips_sys](https://twitter.com/coding_tips_sys)
- [https://twitter.com/vsevsezaebali](https://twitter.com/vsevsezaebali)
- [https://twitter.com/memes_zaebali](https://twitter.com/memes_zaebali)
- [https://twitter.com/name4tumblr](https://twitter.com/name4tumblr)
- [https://twitter.com/TwitorDrivenDev](https://twitter.com/TwitorDrivenDev)
- [https://twitter.com/softwaredriven](https://twitter.com/softwaredriven)
- [https://twitter.com/crafteveryword](https://twitter.com/crafteveryword)
- [https://twitter.com/eto_kogda_ebut](https://twitter.com/eto_kogda_ebut)

## Предпочитаемая музыка

### New Beat
- X-Commando
- Amnesia
- Dirty Harry
- The Beat Pirate
- Indicate

### Acid House
- BX-8017
- Jarvic 7
- Mike Dred
- RaTaXeS SA FreeSysTeM

### Electropunk / Anhalt EBM
- Container 90
- Kommando XY
- Kropp
- EM:KO
- Jaeger 90

### Neue Deutsche Welle
- Malaria
- Palais Schaumburg
- Frl. Menke
- Christoph Kreutzer
- Polar Pop
- Christiane F.

### EBM
- Leæther Strip
- Engelteck-7
- Schakt Neun
- Gruppe Borsik
- Escalator
- Noise Unit
- Klinik

### Minimal synth / Coldwave
- Blackie
- Kap Bambino

### Retrowave / Synthwave
- NightStop
- Lazerhawk
- Cluster Buster
- Suicide Forest

### Italo disco
- Scotch
- Fred Ventura
- Love

### Stoner / Punk / Garage
- Рандомные местные концерты

### Industrial / Experimental / Avantgarde
- Nurse With Wound
- Coil
- Clock DVA
- Felix Kubin

### Chiptune
- Random soundcloud

### Различный русский трэшачок
- Кобыла и трупоглазые жабы искали цезию нашли поздно утром свистящего хна
- Влажные ватрушки
- Ансамбль христа спасителя
- Armour Breaker
- Барто

## Комиксы
- Saturday Morning Breakfast Cereal
- Оглаф
- CTRL+ALT+DEL
- Тёмные века
- XKCD

## Посещённые концерты

### and proud
- cut copy
- karl bartos
- kalashnikov
- matsumoto zoku
- the dad horse expirience
- Clock DVA
- Ben Frost
- Барто
- Звёзды
- The Meantraitors
- Junk riot
- Кобыла и трупоглазые жабы искали цезию нашли поздно утром свистящего хна

### Прочее
- butterfly temple
- melotron
- and one
- teslaboy
- love cult
- смола
- матушка гусыня
- gnoomes
- СПБЧ
- Disciplina Medicina
- Vice Versa
- Polska Radio One
- Jars
- Мразь
- Blues Bastards
- ВХОРЕ
- Боровик Ералаш

### Местные
- krnangh
- panicforce
- 4 позиции бруно
- стройбат
- spoilers
- the stockmen
- karovas milkshake
- gazoliners
- текстура
- городок чекистов
- Наука Сна
- Garry Drummer Orchestra
- Концы
- The Quirks

## Созданные сообщества и коллективные аккаунты, которые я вёл
- [https://twitter.com/kernelunderhood](https://twitter.com/kernelunderhood) - твиттер о системном программировании
- [https://vk.com/weirdedout](https://vk.com/weirdedout) - музыка
- [https://vk.com/newbeatmusic](https://vk.com/newbeatmusic) - музыка
- [https://vk.com/clock_dva](https://vk.com/clock_dva) - музыка
- [https://vk.com/cevirmovies](https://vk.com/cevirmovies) - шуточки

## Спектакли

### Коляда

- Клаустрофобия
- Курица
- Девушка моей мечты
- Нюня
- Наташина мечта
- Старые песни о главном
- Безымянная звезда
- Концлагеристы
- Пиковая дама
- Маскарад

### ЦСД

- Свингеры
- Как Зоя гусей кормила
- Бес небес
- Дом у дороги

### Молодежный театр на Булаке

- Скамейка

### Волхонка

- Пиковая дама

### Teatr Slaski

- Женитьба

### Ангажемент (Тюмень)

- Край

## Игры

### PC
- Morrowind
- Vampires the masquerade: bloodline
- Mafia 2
- Skyrim
- Fallout 3
- Fallout New Vegas
- Fallout 4
- Dark Souls 2
- Mortal Kombat Komplete Edition
- Uncharted Waters Online

### Sega
- Uncharted Waters - New Horizons
- Comix Zone
- Phantasy Star IV
- Rock'n'Roll Racing
- Shinobi III - Return of the Ninja Master
- Fatal Labyrinth
- Sonic the hedgehog 3
- Streets of Rage III

### Nintendo
- Blaster Master
- Chip'n'dale 2
- Excitebike
- Contra Force
- Kage

## Wishlist

- [Пауэрбанк](https://market.yandex.ru/product/13884054?nid=56035)
- Site Reliability Engineering: How google runs production software (бумажная)
- [Игоры в steam](http://steamcommunity.com/id/oleg_strizhechenko/wishlist/)
- Хорошие курсы с менторами (рекомендации, проведение, дары) по:
  - javascript
  - flask
- Пулл реквесты:
  - [Утилиты для мониторинга и тюнинга сетевого стека Linux](https://github.com/strizhechenko/netutils-linux)
  - [Тулза для взаимодействия с Uber](https://github.com/strizhechenko/uber-cli)
  - Библиотеки для [написания твиттер-ботов](https://github.com/strizhechenko/twitterbot_utils) и [их взаимодействия](https://github.com/strizhechenko/twitterbot_farm). Сейчас используются для аккаунтов:
    - [Эт когда в жопу ебут](https://twitter.com/eto_kogda_ebut)
    - [Всё запрещено по плану](https://twitter.com/zapretbot)
    - [Harry Potter & Shit](https://twitter.com/HarryTwibotter)
    - [SocialConstructBot](https://twitter.com/SocConstructBot)
  - [Твиттер-бот с автозаменой на Golang (gin + jquery)](https://github.com/strizhechenko/go-twitterbot-replacer). Сейчас используется для аккаунта ["Программировать надо"](https://twitter.com/__coding_tips__)
  - [Гайд по программированию на bash (типа unofficial shell strict mode)](https://github.com/strizhechenko/shell-scripting-guide)

Также можно просто подкинуть мне баблишка на VPS/пивко

- [рокетбанк](https://rocketbank.ru/oleg.strizhechenko)
- [paypal](https://www.paypal.me/weirded)
