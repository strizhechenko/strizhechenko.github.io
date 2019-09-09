---
layout: post
title: "Заметки об influxdb, grafana, kapacitor, telegraf и collectd"
date: '2015-05-30 10:17:06'
tags:
- influxdb
- delta
- aggregate
- diff
- derivative
- functions
- query
---

## Метрики

### Растущие

Как правильно считать изменения в растущей величине, например как растёт число пакетов на сетевом интерфейсе:

``` sql
SELECT Derivative(total_packets)
FROM packets
GROUP BY time(1m)
```

Все [агрегирующие функции](http://influxdb.com/docs/v0.7/api/aggregate_functions.html) в influxdb требуют группировки по времени, разница между всеми записанными time_series считаться не будет. Из

```
1432980140000 1300
1432980143000 1400
1432980146000 1550
```

не получится

```
1432980143000 100
1432980146000 150
```

### Обнуляющиеся

Счётчики пакетов при переполнении обнуляются. `Derivative()` что-то в духе:

```
1000
-70000000
900
1100
1000
```

Это решается использованием функции `non_negative_derivative()`.

## Зарезервированные слова

`time` - зарезервировано. Создать такую колонку и писать в неё не получится, предположительно передаваемые значения заменяются текущим временем.

## Raw query в grafana

Если уж решились писать `raw_query` - значит вы должны писать их правильно. Что напишите, то и будет запрашиваться у сервера. Нагрузка на базу и процессор от запросов, которые отдают большое количество данных, высока, выполняются они секунд по 20. Это чревато долгой отрисовкой Dashboard. Как этому противодействовать?

### Используйте "where $timeFilter"

В таком случае в запрос передаётся выбранный таймфильтр из веб-интерфейса Grafana.

### Не отказывайтесь от группировки по времени

Если вы пишите в базу чаще чем раз в секунду и вам нужны высокоточные данные, из-за чего вы хотите избавиться от группировки - попробуйте хотя бы указать `group by 1s`. Если вы отслеживаете с помощью графиков аномалии, попробуйте использовать функции `min()` и `max()`.

## Интеграция с Collectd

Заводится легко, позволяет не писать собственный агент, собирающий и отправляющий метрики. Из коробки умеет слать следующее:

``` shell
$ list series
$HOSTNAME/cpu-0/cpu-idle
$HOSTNAME/cpu-0/cpu-interrupt
$HOSTNAME/cpu-0/cpu-nice
$HOSTNAME/cpu-0/cpu-softirq
$HOSTNAME/cpu-0/cpu-steal
$HOSTNAME/cpu-0/cpu-system
$HOSTNAME/cpu-0/cpu-user
$HOSTNAME/cpu-0/cpu-wait
$HOSTNAME/cpu-1/cpu-idle
$HOSTNAME/cpu-1/cpu-interrupt
$HOSTNAME/cpu-1/cpu-nice
$HOSTNAME/cpu-1/cpu-softirq
$HOSTNAME/cpu-1/cpu-steal
$HOSTNAME/cpu-1/cpu-system
$HOSTNAME/cpu-1/cpu-user
$HOSTNAME/cpu-1/cpu-wait
$HOSTNAME/df/df-dev-shm
$HOSTNAME/df/df-root
$HOSTNAME/interface/if_errors-br0
$HOSTNAME/interface/if_errors-eth0
$HOSTNAME/interface/if_errors-eth1
$HOSTNAME/interface/if_errors-lo
$HOSTNAME/interface/if_octets-br0
$HOSTNAME/interface/if_octets-eth0
$HOSTNAME/interface/if_octets-eth1
$HOSTNAME/interface/if_octets-lo
$HOSTNAME/interface/if_packets-br0
$HOSTNAME/interface/if_packets-eth0
$HOSTNAME/interface/if_packets-eth1
$HOSTNAME/interface/if_packets-lo
$HOSTNAME/load/load
$HOSTNAME/memory/memory-buffered
$HOSTNAME/memory/memory-cached
$HOSTNAME/memory/memory-free
$HOSTNAME/memory/memory-used
```

Но в конфигурационном файле можно включить [дополнительные плагины](https://collectd.org/documentation.shtml). Шлёт информацию своим бинарным протоколом по UDP. Схема записи в InfluxDB удобная, позволяет в запросах делать так:

``` sql
SELECT mean(value) FROM /cpu*/ GROUP BY time(1h)
```

## Интеграция с Kapacitor

Kapacitor - алертер на Go, созданный специально для работы с InfluxDB.

### Разные loglevel

Пример для low-latency хоста. Процессор всегда должен быть почти свободен, если это не так - это аномалия.

``` python
stream
    |from()
        .measurement('cpu')
    |alert()
        .info(lambda: "usage_idle" < 95)
        .warn(lambda: "usage_idle" < 90)
        .crit(lambda: "usage_idle" < 80)
        .slack()
        .channel('@weirded')
```

Проверка: запускаем в новых окнах команду:

``` shell
grep -o -a 'rrr' /dev/urandom > /dev/null
```

Оффтоп: кстати, grep довольно прожорливая^Wочень эффективно использующая имеющиеся ресурсы штука, как и вообще вся работа с текстом, если её вовремя не останавливать. Съесть 100% CPU ему ничего не стоит.

```
cpu:nil is WARNING
cpu:nil is CRITICAL
cpu:nil is WARNING
cpu:nil is OK
```

### Добавление имени хоста на котором произошло событие

``` python
stream
    |from()
        .measurement('cpu')
    |alert()
	    .id('{{.Tags}}')
	    .message('{{.ID}} is in {{.Level}} state because of usage_idle value: {{ index .Fields "usage_idle" }}')
        .warn(lambda: "usage_idle" < 90)
        .crit(lambda: "usage_idle" < 70)
        .crit(lambda: "usage_idle" < 70)
        .log('/tmp/alerts.log')
        .slack()
	.channel('@weirded')
```

На выходе:

```
map[cpu:cpu-total host:influxdb-test-deploy] is in WARNING state because of value: 87.39076154796331
map[cpu:cpu-total host:influxdb-test-deploy] is in OK state because of value: 95.49999999999272
```

## Интеграция с Telegraf

### Как указать разные интервалы сбора с помощью нескольких плагинов-коллекторов

Укажите несколько секций `[inputs.exec]` и у каждой укажите свой интервал. Пример:

``` python
[inputs.exec]
  commands = ["/etc/telegraf/telegraf.d/my-collector.sh 1m"]
  interval = "1m"

[inputs.exec]
  commands = ["/etc/telegraf/telegraf.d/my-collector.sh 10s"]
  interval = "10s"
```

Зачем такое может понадобиться?

- Есть редко изменяющиеся, либо требующие ресурсов и времени на сбор данные (обращения к внешним серверам). В то же время есть данные, которые нужно собирать постоянно и которые собираются быстро (содержимое/размер текстовых файлов, счетчики).
- Для изоляции сложности двумя местами: свой конфиг в `telegraf.d` и ваш скрипт-коллектор `my-collector.sh`. Что они будут получать и какие метрики выводить - станет заботой тех частей приложения, которые они вызывают.


## Заметки по релизу 0.9.0

[Написал статью на хабр](http://habrahabr.ru/post/262565)

## У grafana появился RPM-репозиторий

Теперь можно:

``` shell
service grafana-server stop
yum -y update grafana-server
service grafana start
```

При миграции с 2.6.0 на 3.0.3 никаких проблем не случилось.

## Минусы InfluxDB

Обновление с 0.9.0 на 0.13.0 не удалось. Надо было с 0.9.0 на 0.11.0, а оттуда уже на 0.13.0. Что-то связаное с форматами данных в шардах было.

- Отсутствие интеллектуального обновления конфига при обновлении - удаление устаревших опций, сохранение того, что изменено пользователем, добавление новых пунктов. Новый конфиг просто лежит рядом.
- Init скрипт считает сервер запустившимся, хотя тот упал при запуске, узнать об этом можно только в логах.
- Нет yum-репозитория для обновления и опции "автоматическое обновление".
