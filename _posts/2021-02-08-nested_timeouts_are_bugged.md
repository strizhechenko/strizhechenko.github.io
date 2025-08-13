---
title: Всё должно иметь таймаут, но вложенные таймауты в Linux не работают.
---

**TL;DR**: timeout опосредованно перехватывает сигналы от вышестоящего timeout.

Дело в том что timeout посылает сигнал не непосредственно своему ребёнку, а всей группе процессов кроме себя. И чтобы не убить родителя, он при запуске меняет группу (себя и всех своих детей). Поэтому kill(0, sig); от родительского таймаута до него не доходит.

Поэтому может быть ситуация:

/daemon/daemon

``` shell
main() {
  init
  while true; do
    timeout -s 15 300s /daemon/do_job
  done
}
```

/daemon/do_job

``` shell
main() {
   blah blah
   blah
   timeout -s 15 60s /daemon/_sub_job
}
```

и если blah-blah занимают много времени, то 300s таймаут из демона не убьёт `/daemon/_sub_job`.

## Странные эксперименты

Воспроизведение проблемы

``` shell
time timeout -s 15 1s timeout -s 15 2s sleep 3

real	0m2.002s
user	0m0.000s
sys	0m0.001s
```

Куча дебага напиханная в `timeout.c`

``` shell
$ time ./timeout -s 15 1s ./timeout -s 15 2s ./sleeped.sh 3
[9627:10026] started
[10026:-1494693979] switch process group from 65006999 to 10026
[10026:10027] started
[10026:1832687544] switch process group from -483967593 to 10027
10027:10028 sleep 3
[9627:10026] cleanup 14
[9627:10026] SIGALARM
[9627:10026] monitored pid, sig 15
[9627:10026] send_sig send to 0 signal 15
[9627:10026] cleanup 15
[9627:10026] monitored pid, sig 15
[9627:10026] sending sigcont
[9627:10026] send_sig send to 0 signal 18
[10026:10027] cleanup 14
[10026:10027] SIGALARM
[10026:10027] monitored pid, sig 15
[10026:10027] send_sig send to 0 signal 15
[10026:10027] cleanup 15
[10026:10027] monitored pid, sig 15
[10026:10027] sending sigcont
[10026:10027] send_sig send to 0 signal 18

real	0m2.002s
user	0m0.001s
sys	0m0.000s
```

А так вроде бы работает:

``` shell
$ time timeout -s 15 1s bash -c '( timeout -s 15 2s sleep 3 )'
real	0m1.001s
user	0m0.000s
sys	0m0.000s
```

Но не всё так просто:

``` shell
$ time ./timeout -s 15 1s bash -c '( ./timeout -s 15 2s ./sleeped.sh 3 )'
[9627:12168] started
[12168:-1492547687] switch process group from -30790249 to 12168
[12169:12170] started
[12168:2122659781] switch process group from -1579647593 to 12170
12170:12171 sleep 3
[9627:12168] cleanup 14
[9627:12168] SIGALARM
[9627:12168] monitored pid, sig 15
[9627:12168] send_sig send to 0 signal 15
[9627:12168] cleanup 15
[9627:12168] monitored pid, sig 15
[9627:12168] sending sigcont
[9627:12168] send_sig send to 0 signal 18

real	0m1.001s
user	0m0.001s
sys	0m0.000s
$ [1:12170] cleanup 14
[1:12170] SIGALARM
[1:12170] monitored pid, sig 15
[1:12170] send_sig send to 0 signal 15
[1:12170] cleanup 15
[1:12170] monitored pid, sig 15
[1:12170] sending sigcont
[1:12170] send_sig send to 0 signal 18
```

## И что делать?

### Ограничиться таймаутом на верхнем уровне вызова (выбор автора)

Плюсы: защищены от ошибки программиста, который не закрыл таймаутом что-то потенциально зависающее.

Минусы: долго ждать если что-то внутри зависнет.

### Навешивать таймауты точечно.

Плюсы: быстро дохнуть в нужном месте, +/- актуально в синхронных демонах в духе `while true; do thing; sleep $interval; done`.

Минусы: программист может забыть поставить таймаут на зависающей операции, а может не зная об этом навесить два таймаута.

### Патчить timeout.c встроив в него половину pstree - обходить всё дерево процессов, убивая детей по одному.

Плюсы: будет работать как надо и не надо думать об ошибках программистов.

Минусы: программировать надо. И можно сделать ошибку программиста внутри нового таймаута. А потом какой-нибудь программист будет использовать не тот таймаут. Или будет полагаться на поведение старого таймаута.

