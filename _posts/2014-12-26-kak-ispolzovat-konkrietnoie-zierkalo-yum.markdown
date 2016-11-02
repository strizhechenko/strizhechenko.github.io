---
layout: post
title: "Как использовать конкретное зеркало yum"
date: '2014-12-26 06:45:00'
tags:
- linux
- centos
- fastestmirror
- mirror-yandex-ru
- yum
- tormoza
---

Иногда fastestmirror очень тупит. Сегодня он упорно выбирал мне зеркало, с которого пакеты качались со скоростью около 15кб/сек, тратить 5 минут на установку vim - **неприемлемо**!

Достаточно просто указать конкретное зеркало в конфиге:
/etc/yum/pluginconf.d/fastestmirror.conf

	[main]
    enabled=1
    verbose=0
    always_print_best_host = true
    socket_timeout=3
    hostfilepath=timedhosts.txt
    maxhostfileage=10
    maxthreads=15
    include_only=mirror.yandex.ru