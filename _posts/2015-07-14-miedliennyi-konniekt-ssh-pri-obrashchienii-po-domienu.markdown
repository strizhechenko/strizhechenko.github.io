---
layout: post
title: "Медленный коннект SSH при обращении по домену"
date: '2015-07-14 09:31:29'
tags:
- linux
- centos
- slow_ssh
- nscd
- dns
---

# Исходные данные

- Домен хоста: xxxx.ru
- IP хоста: x.x.x.x
- nslookup xxxx.ru ≈ 0.1 сек
- Очень долго идёт подключение по ssh, а также telnet по домену:
  - ssh root@xxxx.ru ≈ 5.7 сек
  - telnet xxxx.ru 22 ≈ 5.6 сек
- А по IP быстро:
  - ssh root@x.x.x.x ≈ 0.6 сек
  - telnet x.x.x.x 22 ≈ 0.5 сек
- На удалённом сервере отключены опции UseDNS и GSSAPI, используется OPTIONS=-u0
- Тормозят все CentOS машины в качестве клиента
- Mac OS X в качестве клиента не тормозит

# Решение

## Вариант 1

	yum -y install nscd
    service nscd restart

NSCD - ~~National Socialistic~~ name service cache daemon, плодить энтропию не буду, поэтому вот ссылка на [opennet](http://www.opennet.ru/man.shtml?topic=nscd&category=8&russian=2).

После установки и рестарта подключение по ssh с использованием ключей на географически удалённый сервер стало занимать приблизительно 0.8 сек.

## Вариант 2

Коллега обнаружил ещё одно, более изящное решение.

	echo options single-request >> /etc/resolv.conf