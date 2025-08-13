---
layout: post
title: "Зависают TCP-соединения"
date: '2015-02-27 12:07:01'
---

Обычно такие проблемы возникают когда где-то в сети не состыкованы MTU или что-то ещё. Чаще всего это возникает в случае спутникового интернета.

Что можно сделать?

## Выставить заниженный MSS для TCP средствами iptables

``` shell
iptables -I INPUT -m tcp -p tcp --tcp-flags SYN SYN -m tcpmss --mss 1201:6000 -j TCPMSS --set-mss 1200
iptables -I OUTPUT -m tcp -p tcp --tcp-flags SYN SYN -m tcpmss --mss 1201:6000 -j TCPMSS --set-mss 1200
```

## Уменьшить MTU на устройстве

``` shell
ip link set eth0 mtu 1400
```
