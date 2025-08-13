---
layout: post
title: "Как добавить ntpdate в chroot"
date: '2013-10-02 06:48:00'
tags:
- chroot
- ntp
- ntpdate
- ntpdate_to_chroot
- obnovlieniie_vriemieni
---

Так как я помучался с ошибкой: 

```
Error : Servname not supported for ai_socktype 
```
то думаю пример добавления и запуска ntpdate в chroot не будет лишним.

Указываем CHROOTDIR в который добавляем ntp

``` shell
CHROOTDIR=/container/
```

ставим в основную систему ntp, копируем его в chroot
``` shell
yum install ntp
mkdir -p $CHROOTDIR/bin
cp -a /usr/sbin/ntpdate $CHROOTDIR/bin/ntpdate
```

Ему потребуется знать о том, что он работает на 123/udp, 123/tcp, а также знать текущую зону, а ещё ему нужны библиотеки:  

``` shell
mkdir -p $CHROOTDIR/etc $CHROOTDIR/lib64
cp /etc/services $CHROOTDIR/etc/services
cp /etc/localtime $CHROOTDIR/etc/localtime
cp -v /lib64/{libcap.so.2,libidn.so.11,libnss_files.so.2} $CHROOTDIR/lib64/
```

Нужно добавить в firewall разрешение этого трафика

``` shell
iptables -I INPUT -p tcp --dport 123 -j ACCEPT
iptables -I OUTPUT -p tcp --dport 123 -j ACCEPT
```

Теперь можно и проверить:

chroot $CHROOTDIR ntpdate -4 -t 1 0.centos.pool.ntp.org
```
