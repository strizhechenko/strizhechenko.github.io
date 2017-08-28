---
layout: post
title: "Как жить если ты в магадане?"
date: '2015-02-27 12:07:01'
---

Обычно такие проблемы возникают когда где-то в сети не состыкованы MTU или что-то ещё. Чаще всего возникает в случае спутникового интернета.

```
iptables -I INPUT -m tcp -p tcp --tcp-flags SYN SYN -m tcpmss --mss 1201:6000 -j TCPMSS --set-mss 1200
iptables -I OUTPUT -m tcp -p tcp --tcp-flags SYN SYN -m tcpmss --mss 1201:6000 -j TCPMSS --set-mss 1200
```

Альтернативный вариант:

Уменьшить MTU на линке, через который выходим в интернет:

```
ip link set eth0 mtu 1400
```
