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

Error : Servname not supported for ai_socktype 
то думаю пример добавления и запуска ntpdate в chroot не будет лишним.# указываем CHROOTDIR в который добавляем ntpCHROOTDIR=/usr/local/Reductor/reductor_container/# ставим в основную систему ntpyum install ntp# копируем его в chrootmkdir -p $CHROOTDIR/bincp /usr/sbin/ntpdate $CHROOTDIR/bin/ntpdate# ему потребуется знать о том, что он работает на 123/udp, 123/tcp.mkdir -p $CHROOTDIR/etccp /etc/services $CHROOTDIR/etc/services# а также знать текущую зонуcp /etc/localtime $CHROOTDIR/etc/localtime# нужно добавить в firewall разрешение этого трафика# iptables -I INPUT -p tcp --dport 123 -j ACCEPT# iptables -I OUTPUT -p tcp --dport 123 -j ACCEPT# а ещё ему нужны либыmkdir -p $CHROOTDIR/lib64cp -v /lib64/{libcap.so.2,libidn.so.11,libnss_files.so.2} $CHROOTDIR/lib64/# теперь можно и проверитьchroot $CHROOTDIR ntpdate -4 -t 1 0.centos.pool.ntp.org