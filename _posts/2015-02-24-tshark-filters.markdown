---
layout: post
title: Виды фильтров в tshark
date: '2015-02-24 09:26:24'
tags:
- tshark
- filters
- tcpdump
---

## Виды фильтров

- display - что отображать из того что наловлено
- capture - что ловить
- output - что отображать из того что решили отображать

Иными словами:

``` shell
tshark -n -i eth1 tcp -R "tcp.flags.push==1"
```

здесь имеем два фильтра. capture - `tcp` и display - `-R tcp.flags.push==1`

output можно использовать следующим образом:

``` shell
tshark -n -i eth1 tcp -R "tcp.flags.push==1" -Tfields -e tcp.request.method
```

он позволяет сформировать формат вывода, почти как `printf`.

## Примеры

### Распределение длин tcp-заголовков HTTPS-запросов на 1000 пакетов.

``` shell
tshark -n -i any -c 1000 tcp dst port 443 -T fields -e tcp.hdr_len | sort | uniq -c | sort -nk1
```

### Найти свой Client Hello

``` shell
ip=1.2.3.4
host=kek.com
tshark -n -V -c 100 -i eth1 -f "src host $ip and tcp dst port 443" -R "tcp contains $host"
```
