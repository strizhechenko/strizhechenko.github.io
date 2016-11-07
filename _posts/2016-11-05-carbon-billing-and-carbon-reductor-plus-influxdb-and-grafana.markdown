---
layout: post
title: "Carbon Billing Softrouter 5 + Grafana + InfluxDB"
date: '2016-11-05 04:19:00'
tags:
- carbonsoft
- billing
- telecom
- ISP
- Grafana
- InfluxDB
- time-series
- DPI
- reductor
- radius
- collectd
---

# С чего всё началось

Захотелось мне посмотреть на наш основной продукт, биллинг. Красивый ли он, есть ли аналитика, на которую взглянуть приятно аль нет. И что-то не особо. То есть я не хочу сказать, что он беден на аналитику, отчётов там дохрена, отчёт "Для Директора" даже довольно таки красивый (настолько, даже моя ненависть к ущербному неуместному использованию больших букв останется в рамках этих скобочек!). Но остальные же отчёты - сраная скучная текстовая табличка в браузере, которую можно выгрузить в CSV/Excel/DBF (wow!).

И захотелось мне узнать, можно ли любопытному провайдеру прикрутить туда что-то красивое и прекрасное самостоятельно, не формируя сложное техническое задание нашим суппортам, не создавая 50 фич-реквестов и всё такое, не покупая для этого высокоуровневую подписку (SLA4-аутсорсинг или какие там сейчас у нас модные).

Собственно стэк решил использовать привычный мне:

- grafana для отображения графиков
- influxdb как хранилище метрик
- python как инструмент опроса биллинга и отправки метрик в influxdb
- crond как пинатель питоновых скриптов

Disclaimer: Никаких алертеров или чего-то сверхумного, детекторов аномалий, больших данных и машинного обучения тут не будет. Просто приемлемая визуализация.

# Установка

Всё ставится на отдельную машину. Я втыкал в CentOS 6 внутри OpenVZ контейнера. Разворачивал всё с помощью ansible, есть правда косяк в плейбуке, надо вручную одно подтверждение сделать при установке grafana:

```yaml
- hosts: [influxdb]
  tasks:
  - name: grafana.repo
    copy: src=../files/grafana.repo dest=/etc/yum.repos.d/grafana.repo
  - name: grafana
    yum: name=grafana state=present
  - name: grafana
    yum: name=cronie state=present
  - name: enable crond
    service: name=crond enabled=yes state=restarted
  - name: enable grafana
    service: name=grafana-server enabled=yes state=restarted
  - name: influxdb
    yum: name=https://dl.influxdata.com/influxdb/releases/influxdb-1.0.2.x86_64.rpm state=present
  - name: enable influxdb
    service: name=influxdb enabled=yes state=restarted
```

Поскольку раз уж всё равно экспериментирую в своё свободное время, решил использовать python3.4. Вообще я на нём особо не пишу, так что возможно будет много косяков ниже в статье в примерах кода.

# Пробуем юзать

## Настраиваем InfluxDB

Открываем 8083 порт виртуалки в первый и в последний раз, чтобы создать базу и настроить политики устаревания и удаления данных. Бигдаты тут как я уже говорил не ожидается, так данные за полгода отлично уместятся на одной машинке без всяких кластеров.

```sql
CREATE DATABASE "softrouter";
CREATE RETENTION POLICY "limitations" ON "softrouter" DURATION 180d REPLICATION 1 DEFAULT;
```

## Настраиваем Grafana

Открываем :3000 порт в первый и далеко не последний раз, вводим admin/admin, меню -> data sources -> + add data source.

- name softrouter
- default: +
- type influxdb
- url http://localhost:8086
- database softrouter

Больше особо менять не надо.

Дальше Dashboards -> Create New -> Зелёная херня сбоку -> Add Panel -> Graph. Теперь временно забываем про графики и начинаем думать что бы нам такого пособирать из данных.

## Собираем данные

Вообще данные в нашем случае делятся два вида - технические и бизнес.

Поскольку я обкатываю всё на нашем тестовом софтроутере, который служит нам на работе гейтом в инет, то начну с технических.

### Технические

Так как у нас под коробкой - Linux, собирать системные данные проще всего с помощью collectd. Там даже думать особо не надо, всё есть в репах.

```shell
yum -y install collectd
```

Поскольку машинка занимается сетью, раскомментируем в /etc/collectd.conf следующие плагины, а также поменяем пару параметров:

```
Interval 60
LoadPlugin conntrack
LoadPlugin disk
LoadPlugin iptables
LoadPlugin irq
LoadPlugin network
LoadPlugin swap
LoadPlugin tcpconns
LoadPlugin uptime

<Plugin network>
        <Server "ip influxdb" "25826">
        </Server>
</Plugin>
```

Ну, не надо нам реалтайм статистику. Как по мне и 60 секунд интервал - черезчур много. Где-нибудь 300 - самое оно, если не делаем никакого алертинга и всё для "пост-проблемного" анализа, а не превентивного.

Делаем:

```
service collectd restart
```
Когда-нибудь я разберусь как лучше мониторить запущенный в чруте nginx, он тут тоже полезен.

На стороне сервера с influxdb делаем:

```shell
yum -y install collectd
```

Здесь он нужен только ради одного файла, types.db. В автостарт его можно не ставить. Плюс в конфиге influxdb правим секцию collectd:

``` ini
[[collectd]]
  enabled = true
  database = "softrouter"
  typesdb = "/usr/share/collectd/types.db"
```

и

```
service influxdb restart
```

После чего по адресу :8083 можем наблюдать в выводе

```
show measurements
```

всё, за чем мы теперь можем наблюдать, у меня:

- conntrack_entropy
- cpu_value
- disk_read
- disk_write
- interface_rx
- interface_tx
- irq_value
- load_longterm
- load_midterm
- load_shortterm
- memory_value
- swap_value
- tcpconns_value
- uptime_value

В случае с шлюзом и DPI очень важными являются interface_rx и interface_tx. С них и начнём.

Вот пример запроса про входящий pps на eth0 для grafana:

```sql
SELECT non_negative_derivative(mean("value"), 1s) FROM "interface_rx" WHERE "host" = 'Gate' AND "type" = 'if_packets' AND "type_instance" = 'eth0' AND $timeFilter GROUP BY time($interval) fill(null)
```

#### Шаблонизирование в grafana

Вообще много графиков которые находятся рядом имеют очень похожие запросы в основе, меняется как правило одна переменная. Чтобы не менять постоянно в куче мест запросы, можно использовать settings -> templating.

Сперва добавляем новую переменную, назовём её uptime_kind, type = custom. Values:

load_longterm, load_middleterm, load_shortterm

Multivalue: +

Сохраняем, теперь вверху можно выбирать. Выбираем все. В настройках графика с uptime выбираем from default /^uptime_kind$/ (не забываем указывать host, который кстати тоже можно использовать в шаблонизации).

Теперь идём в general -> repeat panel -> uptime_kind. Ставим span=4, minimal span=4, сохраняем и обновляем страницу. Кстати, переменные можно подставлять куда угодно => темплейтить можно всё что угодно, даже функции.

#### Ещё примеры данных для сбора

Можно следить за ростом прерываний на сетевых картах.

У нас используется не очень крутая карта, крутится с одной очередью на 26 прерывании.

```sql
SELECT non_negative_derivative(mean("value"), 1s) FROM "irq_value" WHERE "host" = 'Gate' AND "type" = 'irq' AND "type_instance" = '26' AND $timeFilter GROUP BY time($interval) fill(null)
```

#### CPU Usage

#### Memory Usage

#### Шаблонизируем для использования с несколькими хостами

Так как настраивать и использовать целую дэшбордину только ради одного хоста глупо, попробуем воспользоваться ей для других продуктов.

Создадим ansible-playbook для быстрого разворачивания collectd на других машинах и возможности менять конфигурацию в одном месте.

Файл: tasks/collectd.yml:

```ansible-playbook
- hosts: [collectd]
  tasks:
    - name: install
      yum: name=collectd state=present
    - name: configure
      template: src=../templates/collectd.conf.j2 dest=/etc/collectd.conf
    - name: enabled
      service: name=collectd enabled=yes state=restarted
```

Файл: templates/collectd.conf:

```
FQDNLookup   false
Interval     60
LoadPlugin syslog
LoadPlugin conntrack
LoadPlugin cpu
LoadPlugin disk
LoadPlugin interface
LoadPlugin iptables
LoadPlugin irq
LoadPlugin load
LoadPlugin memory
LoadPlugin network
LoadPlugin swap
LoadPlugin tcpconns
LoadPlugin uptime
<Plugin disk>
	Disk "/^sda[0-9]$/"
	IgnoreSelected false
</Plugin>
<Plugin network>
Server "10.50.140.131"
</Plugin>
Include "/etc/collectd.d"
```

По красивому IP адрес сервера с collectd надо вынести в переменные группы в файле inventory, но я отложу это на потом.

Запускаем:
```
ansible-playbook tasks/collectd.yml -l IP-второй-машины
```

В templating в grafana добавим переменную Host:

type = query, multivalue отключаем, обновлять только при загрузке dashboard, сам query:
```
SHOW TAG VALUES FROM "cpu_value" WITH KEY = "host"
```

Единственная проблема которая при такой схеме будет - это отслеживание IRQ сетевых карт. Но в принципе можно отнести это к бизнес-логике, а не техническим данным и захардкодить для каждого хоста (прости господи) или вынести на сторону какого-то своего плагина к collectd.

### Бизнес-данные

Итак, переходим к самому интересному. Если технические данные, описанные выше, можно отслеживать любой системой мониторинга из коробки, то с специфическими для биллинга - придётся немного повозиться. Собственно, чтобы облегчить жизнь возящимся эта статья и пишется. Я попробую сделать кое что новое для меня - оформить всё в виде плагинов для collectd вместо дёрганья питона по крону. Но возможно к питону всё равно придётся обратиться за помощью, так как некоторые данные не так легко просто так взять и собрать.

#### Число radius событий за час

#### Число авторизованных абонентов с распределением по NAS-серверам

#### Данные о работе технической поддержки (заявки в хелпдеске)
