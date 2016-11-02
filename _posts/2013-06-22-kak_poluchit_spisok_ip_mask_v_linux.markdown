---
layout: post
title: "Как получить список IP/MASK в Linux"
date: '2013-06-22 12:43:00'
tags:
- egrep
- ip
- poluchit_spisok_ip_i_masok_v_linux
---

На мой взгляд самый простой способ - ниже:

ip a | egrep -wo '([0-9]{1,3}\.*){4}/[0-9]{1,2}'

либо:
ip -o -f "inet" a | awk '{print $4}'

## Как это работает
ip a - выводит список адресов, например

1: lo: <loopback,up> mtu 16436 qdisc noqueue </loopback,up>
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
2: Eeth2: <broadcast,multicast,up> mtu 1500 qdisc pfifo qlen 1000</broadcast,multicast,up>
    link/ether 52:54:00:40:2d:6e brd ff:ff:ff:ff:ff:ff
    inet 10.90.140.5/16 scope global Eeth2
3: Leth1: <broadcast,multicast,up> mtu 1500 qdisc pfifo qlen 1000</broadcast,multicast,up>
    link/ether 52:54:00:52:51:dc brd ff:ff:ff:ff:ff:ff
    inet 192.168.5.1/24 scope global Leth1
4: cipcb0: <pointopoint,noarp> mtu 1418 qdisc noop qlen 100</pointopoint,noarp>
    link/ipip 00:00:5e:b2:00:6e peer ff:ff:ff:ff:ff:ff
5: dummy0: <broadcast,noarp,up> mtu 1500 qdisc noqueue </broadcast,noarp,up>
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
    inet 10.128.0.0/32 scope global dummy0
6: imq0: <noarp,up> mtu 1500 qdisc htb qlen 30</noarp,up>
    link/void 
7: imq1: <noarp,up> mtu 1500 qdisc htb qlen 30</noarp,up>
    link/void 
Ключи egrep:-w - ищет слово целиком-o - выводит только то, что подходит под заданный шаблонВ оригинале регулярное выражение выглядело так:

'([0-9]{1,3}\.){3}[0-9]{1,3}'

И оно отлично справлялось со своей задачей - вывести IP адрес.В случае необходимости выводить ещё и маску - оно становилось излишне громоздким, поэтому я упразднил проверку наличия точек после первых трёх октетов и отсутствие после последнего. Вместо этого:
'([0-9]{1,3}\.*){4}/[0-9]{1,2}'

Проверяем наличие четырёх разделённых или неразделённых точкой чисел от 0 до 999 и ещё одного числа от 0 до 99, разделённых между собой слэшем. Команда ip addr всё равно не покажет нам чего-то другого, подходяшего под эту регулярку, выглядит она достаточно компактно.