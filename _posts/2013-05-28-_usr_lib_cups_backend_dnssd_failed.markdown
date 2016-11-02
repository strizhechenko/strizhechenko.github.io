---
layout: post
title: "/usr/lib/cups/backend/dnssd failed"
date: '2013-05-28 06:27:00'
tags:
- linux
- _usr_lib_cups_backend_dnssd_failed
- dnssd
- ubuntu
- printier_nie_piechataiet
---

Внезапно ни с того ни с сего перестала работать печать на офисный принтер, с ошибкой

/usr/lib/cups/backend/dnssd failed

Решение нагуглилось достаточно простое - изменить в свойствах принтера его URL с

dnssd://что-то-там-HP-LaserJet-бла-бла-бла.tcp.local

на банальное

socket://$printer_ip:9100
в принципе ничего в плане функционала не изменилось, зато заработало, а разбираться почему это произошло... Староват я уже наверное для таких забав, чтобы чинить дистрибутив Linux, который больше не поддерживается :)