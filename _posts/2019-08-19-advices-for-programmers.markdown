---
title: Советы для программистов (с историями)
---

Собрал все свои статьи по этой теме за 8 лет в одну.

## Не пишите код сразу

Я часто использую virsh. Мне захотелось дотабывать его команды, а в стандартной поставке этого не было. Что делает человек, который ценит своё время? **Гуглит не написано ли оно уже**, и только после этого начинает писать код. А не наоборот, [как я](https://github.com/hordecore/configs/blob/master/virsh). Оказывается [всё давно написано за полтора года до меня](http://www.redhat.com/archives/libvir-list/2011-October/msg00141.html) неким Serge E. Hallyn.

## Как обновлять большие системы

Иногда причиной проблем после обновления становятся изменения в конфигурации, сделанные **до** обновления. Их последствия возникают и замечаются не сразу. Причём после обновления все глаза устремлены к изменениям, которые принесла новая версия. Это создаёт ошибочные гипотезы, проверка которых требует времени, при этом время, когда система некорректно работает. Поэтому перед обновлением обеспечьте хотя бы неделю стабильной работы системы.

## Вообще про обновление

Предыдущую версию можно бэкапить вместо полного удаления.

Продумайте обновление конфигурационных файлов. Значения могут:

- добавляться
- изменяться, только если не были изменены пользователем
- изменяться, даже если были изменены пользователем
- удаляться

Тестируйте обновление на:

- голой системе
- предыдущей версии системы
- давно не обновлявшейся системе
- на намеренно поломанной системе

## Именуйте осмысленно

В Metro Last Light в отладке нашли "пасхалку", которая больше говорит о культуре разработки.

![Неосмыслено](http://img1.joyreactor.cc/pics/comment/Metro-Last-Light-anna-ebat-russian-480425.jpeg)

1. Переменная названа транслитом по-русски.
2. В имени сделана ошибка.

Я слышал истории о плохих условиях, в которых делали эту игру. Возможно, такие переменные встречаются по всему коду игры. Неудивительно, что разработка двигалась туго.

Мне как-то сказали такую фразу: "программиста можно перестать считать джуниором тогда, когда он начинает осмысленно именовать даже временные файлы". Я с ней согласен на все 100.

## Действуйте осмысленно

В августе 2013 года друг написал мне:

> Мне на неттопе надо собрать ядро, чтобы оно скомпилировалось очень быстро и чтобы поддерживалось только используемое железо и функциональность: сетевые карты ethernet и wi-fi, SATA-контроллер, мониторинг температур, swap, процессор Atom и его встроенное видео, даже если без 3D-ускорителей. Будет коробочным веб-сервером, никаких внешних устройств подключать не планирую. Можно ли подогнать размер ядра под, например, ядра роутеров? Еще интересно, можно ли вкомпилить внутрь ядра например nginx и mysql сервер? Как вообще глянуть то, что выполняется до /etc/rc2.d/? Определение оборудования, подгрузка модулей. Я хочу чтоб при старте не было опроса железа на наличие, а тупо подгрузка модулей. Сервисы я уже повыпиливал, у меня даже kern.log не пишется, а еще sysctl подкрутил, чтобы сетевые функции поубирать, форвардинг итд. В inittab только один экземпляр консоли оставил. Можно ещё кастрировать консоль локальную, чтоб при размещении сервака никто не пытался подключить монитор и глянуть че там.

Это отличный пример преждевременной оптимизации: танцуем не от проблем, а от желания поковыряться. Это неплохо само по себе (самообразование), но осознавать нужно.

Все такие удаления приводят к потенциальному будущему неудобству, а прироста производительности практически не дают. Ядро не будет уметь делать некоторые вещи, но если оно этим итак не занимается - разница будет заметна только во времени загрузки ядра и initrd в память.

Делать ядро, заточенное под конкретную железку экономически невыгодно - через год она помрёт, а производитель их больше не выпускает.

**Как резко снизить размер собираемых ядра и модулей**:

1. `make menuconfig`
2. Выбираем "Kernel hacking"
3. Выключаем "Compile the kernel with debug info"
4. Сокращаем размер `/lib/modules/` приблизительно на 1.2Гб.

## Проверяйте именно то, что делаете

В dmesg удалённой машины выводилось:

```
Neighbour table overflow
```

Экспериментальным путём на собственном тестовом стенде я выяснил, что `ip neigh flush dev br0`, после пары выполнений он вычищает около 100 MAC-адресов из памяти. Мне стало лень руками выполнить его раз 10-15, поэтому я выполнил:

``` shell
while true; do
          sudo ip neigh flush dev br0
done
```

в итоге потерял управление удалённой машиной.

Вывод: **проверка команды самой по себе != проверка команды в цикле**. Они будут вести себя по разному.

## Не бойтесь спросить совета

Часто мозг подсказывает не самый быстрый способ выполнения задачи. А у программистов вообще есть тяга к переусложнению. Если сомневаетесь, поговорите со старшими коллегами, расскажите им что надумали, вполне возможно вас конструктивно покритикуют и предложат, как сэкономить несколько часов жизни.

Раньше здесь была моя история, но спустя 6 лет она кажется не особо показательной, поэтому я её удалил.

## Иногда сделать костыль из говна и палок быстрее, чем прочитать man

6 лет назад мне было грустно от того, что я написал такой код, хотя вместо этого мог использовать одну команду date, а сейчас ни капельки.

``` shell
#!/bin/bash

set -eu

nulling() {
    [ "$1" -lt 10 ] && echo "0$1" || echo "$1"
    return 0
}

second2hms() {
    unix_time="$1"
    h="$((unix_time / 3600))"
    d="$((unix_time - h * 3600))"
    m="$((d / 60))"
    s="$((d - m * 60))"
    echo "$(nulling $h):$(nulling $m):$(nulling $s)"
}

second2hms "$1"
```

Как сделать одной командой date:

``` shell
date --date @$1 +%H:%M:%S
```

## Версионируйте или бэкапьте /boot раздел

Мало ли что при обновлении сломается. Как именно - дело вкуса.

- Можно держать git в /boot и по cron его автокоммитить
- Можно btrfs использовать с чем-то вроде snapper
- Может чего-то ещё изобретут в будущем

## Как работать с резюме

У меня было CV на 16 страниц с кучей лишних подробностей, это было ошибкой. Мне в твиттере накидали советов, часть из них я сделал.

1. [ ] Попробуйте сохранить в PDF. Сколько страниц? 2 - хорошо, 1 - отлично.
2. [x] Список книг если уж очень хочется похвастаться, можно сделать ссылкой на отдельную страницу.
3. [x] Ссылки на твиттер не нужны.
4. [x] Опыт работы стоит поместить в начало резюме, начинаться должен с последнего места работы.
5. [ ] Размазанные навыки зло, пишите резюме под конкретные вакансии.
6. [x] Верхняя планка зарплаты не нужна.
7. [x] Малорелевантный опыт работы не нужен.
8. [ ] Про последние места работы - стоит описать какой внёс технический/бизнес вклад.
9. [ ] Стоит посмотреть на шаблоны резюме, там отличная структура.
10. [x] Большое число навыков указывать не нужно, хватит топ 5 интересного, топ 5 по опыту, топ 5 неинтересного. Остальное можно отдельной ссылкой, а лучше выкинуть.
11. [ ] Если поддерживаете англоязычную версию резюме - дайте его перечитать.
12. [x] Полезные качества сдвигайте пониже.
13. [ ] Рядом с работами можно перечислить юзанные инструменты и технологии.
14. [ ] Гляньте cracking the code interview
