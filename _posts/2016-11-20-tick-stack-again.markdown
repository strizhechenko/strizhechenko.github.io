---
layout: post
title: "Разворачивание мониторинга на базе TICK-стэка (ну, почти)"
date: '2016-11-20 18:13:00'
tags:
- influxdb
- ansible
- kapacitor
- telegraf
- collectd
- monitoring
---

**Дисклаймер**: статья - черновик и сброс мыслей за время ковыряния малоопытным человеком. Во многих аспектах я не разбирался, документацию не читал и вообще гнида и сволочь (считаю, что всё должно быть интуитивно и взлетать из коробки, даже если бесплатно и опенсорс).

# Действие первое. Автоматизация деплоя.

Вообще всё крутить планируется в OpenVZ'шках с CentOS 6, а разворачивать с помощью ansible. И здесь у influxdata начинается ебический геморрой с довольно большой цепочкой:

## Неудобно ставить пакеты

1. У них нет RPM-репозиториев, только скачивание RPM'ок. Тут есть свои минусы (нельзя автоматом скачать последнюю версию) и свои минусы (автоматом деплоиться будет только уже проверенная тобой версия).
2. В CentOS 6.8 "системная" версия python - 2.6. При использовании ansible, `anslble-lint` настойчиво ругается на curl, wget и говорит "качай с помощью модуля `get_url`". Модуль `get_url` вроде бы использует под капотом `python-requests`. А в python 2.6 всё устарело настолько, что мы получим `SNIMissingWarning`.

Выходов из этого, конечно много, но все похожи на стулья из тюремной загадки:

- поднять свой RPM-репозиторий (ееее, больше серверов богу серверов!) и добавлять его в yum.repos.d
- качать по http, благо доступно (поверив своему провайдеру, что тот не делает MitM для influxdata, который вроде как на многострадальном amazon крутит сервер с загрузками)
- забить хер на варнинги и качать wget'ом (который по хорошему кстати надо ещё поставить)
- вообще подсунуть yum-таску ссылку, пусть он с ней возится (и каждый запуск скачивает пакет и говорит)

Пока я экспериментирую, так что обойдусь вариантом с HTTP, потом может быть разверну репу, куда буду периодически подтягивать пакеты и можно будет упростить playbook'и до `yum name=influxdb state=latest`

Итого действия по установке influxdb/kapacitor/telegraf на одну машину (только для того чтобы убедиться что вся схема в целом рабочая):

```
ansible-playbook roles/influxdb/tasks/main.yml -l 192.168.3.15
ansible-playbook roles/kapacitor/tasks/main.yml -l 192.168.3.15
ansible-playbook roles/telegraf/tasks/main.yml -l 192.168.3.15
```

## Хотелки к ansible

Вот пока всё это делал, подумал, кстати, что ansible не хватает плагина для atom с autocomplete для всех модулей. Так, чтобы пишешь:

```
    - name: blabla
      copy:
```

и тут тебе сразу так вываливается:

```
  copy: src=../files/(и тут выбор файлов которые ща в нужном files есть) dst=/dst/
```

ну короче просто чтобы по человечески было. Ну да ладно, это не суть.

**TODO: выложить на гитхаб в виде репы (без slack url).**

# Собственно к Kapacitor

Всё выше - это только подготовка тестового окружения для игры с kapacitor. Kapacitor - это довольно умный алертер на Go, запиленный специально для работы с InfluxDB.

Итак, у меня в принципе работает алертинг из документации. Telegraf служил просто примером, по факту он мне не нужен и я заменю его на collectd.

## Вербозные алерты в слак

Однако уведомления в slack меня пока не радуют - не особо информативно.

> cpu:nil is CRITICAL
>
> cpu:nil is OK

### Разные loglevel'ы

Предположим у нас есть машинка, очень чувствительная к повышению latency. Можно следить за тем, что её процессор имеет БОЛЕЕ чем достаточно ресурсов для того чтобы очень быстро разгребать свои маленькие задачки:

``` shell
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

Поэкспериментируем, постепенно запуская в новых окнах команду:

```
grep -o -a 'rrr' /dev/urandom > /dev/null
```

Оффтоп: кстати, grep довольно прожорливая^Wочень эффективно использующая имеющиеся ресурсы штука, как и вообще вся работа с текстом, если её вовремя не останавливать. Съесть 100% CPU ему ничего не стоит.

> cpu:nil is WARNING

> cpu:nil is CRITICAL

> cpu:nil is WARNING

> cpu:nil is OK

Уже интереснее, не правда ли?

### Теперь о форматировании сообщений

При логировании можно получить все доступные значения:

``` json
{
    "data": {
        "series": [
            {
                "columns": [
                    "time",
                    "time_guest",
                    "time_guest_nice",
                    "time_idle",
                    "time_iowait",
                    "time_irq",
                    "time_nice",
                    "time_softirq",
                    "time_steal",
                    "time_system",
                    "time_user",
                    "usage_guest",
                    "usage_guest_nice",
                    "usage_idle",
                    "usage_iowait",
                    "usage_irq",
                    "usage_nice",
                    "usage_softirq",
                    "usage_steal",
                    "usage_system",
                    "usage_user"
                ],
                "name": "cpu",
                "tags": {
                    "cpu": "cpu-total",
                    "host": "influxdb-test-deploy"
                },
                "values": [
                    [
                        "2016-11-20T11:02:39Z",
                        0,
                        0,
                        75095.710000000006,
                        3.4900000000000002,
                        0,
                        0,
                        0,
                        0,
                        1136.3499999999999,
                        175.72999999999999,
                        0,
                        0,
                        100,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0
                    ]
                ]
            }
        ]
    },
    "details": "{&#34;Name&#34;:&#34;cpu&#34;,&#34;TaskName&#34;:&#34;cpu_alert&#34;,&#34;Group&#34;:&#34;nil&#34;,&#34;Tags&#34;:{&#34;cpu&#34;:&#34;cpu-total&#34;,&#34;host&#34;:&#34;influxdb-test-deploy&#34;},&#34;ID&#34;:&#34;cpu:nil&#34;,&#34;Fields&#34;:{&#34;time_guest&#34;:0,&#34;time_guest_nice&#34;:0,&#34;time_idle&#34;:75095.71,&#34;time_iowait&#34;:3.49,&#34;time_irq&#34;:0,&#34;time_nice&#34;:0,&#34;time_softirq&#34;:0,&#34;time_steal&#34;:0,&#34;time_system&#34;:1136.35,&#34;time_user&#34;:175.73,&#34;usage_guest&#34;:0,&#34;usage_guest_nice&#34;:0,&#34;usage_idle&#34;:100,&#34;usage_iowait&#34;:0,&#34;usage_irq&#34;:0,&#34;usage_nice&#34;:0,&#34;usage_softirq&#34;:0,&#34;usage_steal&#34;:0,&#34;usage_system&#34;:0,&#34;usage_user&#34;:0},&#34;Level&#34;:&#34;OK&#34;,&#34;Time&#34;:&#34;2016-11-20T11:02:39Z&#34;,&#34;Message&#34;:&#34;cpu:nil is OK&#34;}\n",
    "duration": 70000000000,
    "id": "cpu:nil",
    "level": "OK",
    "message": "cpu:nil is OK",
    "time": "2016-11-20T11:02:39Z"
}
```

Как минимум иметь название хоста с которым произошла беда очень хотелось бы. Не беда:

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

> map[cpu:cpu-total host:influxdb-test-deploy] is in WARNING state because of value: 87.39076154796331

> map[cpu:cpu-total host:influxdb-test-deploy] is in OK state because of value: 95.49999999999272

Звучит несколько понятнее, не правда ли?
