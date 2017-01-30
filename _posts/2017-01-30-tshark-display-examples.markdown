---
title: Как пользоваться tshark для сбора статистики
---

Распределение длин tcp-заголовков HTTPS-запросов на 1000 пакетов.

``` shell
tshark -n -i any -c 1000 tcp dst port 443 -T fields -e tcp.hdr_len | sort | uniq -c | sort -nk1
```
