---
title: Как пользоваться tshark для сбора статистики
---

## Распределение длин tcp-заголовков HTTPS-запросов на 1000 пакетов.

``` shell
tshark -n -i any -c 1000 tcp dst port 443 -T fields -e tcp.hdr_len | sort | uniq -c | sort -nk1
```

## Найти свой Client Hello

``` shell
ip=1.2.3.4
host=kek.com
tshark -n -V -c 100 -i eth1 -f "src host $ip and tcp dst port 443" -R "tcp contains $host"
```
