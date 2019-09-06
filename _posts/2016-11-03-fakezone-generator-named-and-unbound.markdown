---
layout: post
title: Сравнение bind и unbound в целях фильтрации трафика по DNS
date: '2016-11-03 15:48:00'
---

## Fakezone

Есть проект [fakezone](https://github.com/carbonsoft/named_fakezone_generator). Его основная задача - блокировать часть запрещённых сайтов по доменному имени на стороне DNS-сервера провайдера, отвечая одним IPv4 адресом страницы-заглушки на их запросы.

У провайдеров в России есть два стула, на которых надо усидеть:

1. Не потерять лицензию или закрыться из-за штрафов.
2. Не потерять абонентов из-за ухудшения качества сервиса.

Реестр запрещённой информации в РФ растёт, число блокируемых доменов растёт с ним. Поэтому решил проверить, как меняется потребление памяти у разных DNS-серверов.

### Зачем использовать DNS-сервер

Использование DNS-сервера для фильтрации нужно, чтобы не устанавливать DPI в разрыв. В противном случае DNS-сервер, использующий DNSSec будет игнорировать ответы DPI. В некоторых схемах сети провайдера трафик к DNS-серверам и от них вообще не попадает в DPI.

### Примечания

Домены с символом `_`. По RFC их не существует. В реестре они есть. На практике:

- **bind9** от таких доменов, оказавшихся в конфиге валится и не стартует, ругаясь. Одно из решений - заменять на дефис.
- **unbound** чувствует себя прекрасно, на запросы об этих доменах отвечает.

### Генерация доменов для тестирования

На коленке был накидан скрипт на python2, красоту наводить не стали, ибо скрипт одноразовый.

``` python
""" domain generator """
from re import sub
from sys import argv
from random import shuffle
from string import ascii_lowercase

zones = [
    'com', 'net', 'ru', 'org', 'uk', 'en', 'ss', 'cn',
]

x = list(ascii_lowercase) + ['1', '2', '3', '4', '.', '.', '.']

for i in xrange(int(argv[1])):
    shuffle(x)
    print sub(r'^\.|\.$', '', "".join(x).replace('..', '.').replace('..', '.')) + '.' + zones[i % len(zones)]
```

На выходе даёт что-то вроде:

```
3zxkljdpytqwev4u1.mgconis2hbaf.r.net
3.gxchap1zu4wt2rvejyqln.bodfms.ik.ru
p2beiw4r.uzydlkhnq.jcf3.xto1gsvma.org
r1ve.os2p.ilzdt4kj.baqycuwfmng3hx.uk
snemj1d.of2huzqkxbcilvag.43ywrpt.en
cbek1pmvlzhowg.st.iy2nx.jq4da3fru.ss
rgct.jqop2l1n3zums.4bayxvkw.eihdf.cn
xecabuy124sdgpqith.omw3.rjlznkvf.com
4zr1mlx3howu.nciajkvb.gq.syptf2ed.net
nh.iq1gxfclt.rpsd4z3j.aevu2bmwoky.ru
ylr.fcvjzumk42q.ontx3g.easwbdp1hi.org
bw4vzrkaenfj.lpsho.ug21.mctyxiq3d.uk
n1gvqf4cwmjkrzphy.32ouxdtaei.bsl.en
qwv.tpgknfjhi.ey.ozrmbx1c3u2ads4l.ss
```

Для тестов вполне подходящие данные, хоть таких доменов скорее всего на самом деле и не существует.

### Замеры

Наблюдения проводились за сервером, находящимся в состоянии "покоя" - к нему обращалась несколько раз тестовая машина только для того, чтобы проверить, что он вообще работает и живой. Оба сервера были развёрнуты в OpenVZ-контейнерах, обоим было выделено 4Гб оперативной памяти.

Число доменов | Unbound VSZ | Unbound RSS | Bind9 VSZ | Bind9 RSS
-----------: | ---------: | ---------: | -------: | -------:
    8500      |    210M     |     49M     |   357M    |   101M
    25000     |    346M     |    157M     |   970M    |   306M
    50000     |    556M     |    315M     |   1299M   |   646M
   100000     |    979M     |    823M     | OOM | OOM
   200000     |    1824M    |    1284M    | OOM | OOM
   400000     |    3515M    |    2655M    | OOM | OOM

### Идеи замеров

- Деградация в скорости ответов
- Замедление рестарта
- PowerDNS и PowerDNS-Recursor
- DNS-спуфер в Carbon Reductor
- Bind10
- NSD сам по себе
- Связка Bind + NSD
- Связка Unbound + NSD

### Выводы

Unbound смотрится сильно выигрышнее Bind в вопросе потребления памяти.

От опроса всех добавленных доменов одним клиентом потребление памяти ни unbound'ом ни bind'ом не менялось.

#### Bind9

После 50000 доменов наступает существенная деградация в скорости рестарта у bind9.

На 100000 доменов без дополнительного тюнинга bind в openvz начал валиться с out of memory error прямо при старте, съев около 1гб памяти.

#### Unbound

На 400000 доменов скорость полного рестарта (с downtime!) у unbound замедляется до ≈14 секунд, что тоже грустно:

``` shell
$ time /etc/init.d/unbound stop
Stopping unbound:                                          [  OK  ]

real  0m1.116s
user  0m0.007s
sys   0m0.003s

$ time /etc/init.d/unbound start
Starting unbound: Nov 04 09:23:14 unbound[30785:0] warning: increased limit(open files) from 1024 to 8290
[  OK  ]

real  0m14.791s
user  0m8.548s
sys   0m3.865s
```

Есть утилита unbound-control, позволяющая менять конфигурацию сервера на ходу, без downtime. В [репозитории](https://github.com/carbonsoft/named_fakezone_generator) она используется для загрузки изменений.

Есть опция: - `domain-insecure: "example.com"`. Она позволяет обрабатывать запросы от unbound модулем DNS-спуфинга. Но с помощью `unbound-control` она не применяется. Это позволяет генерировать конфиг меньшего размера, но слабо влияет на потребляемую память.
