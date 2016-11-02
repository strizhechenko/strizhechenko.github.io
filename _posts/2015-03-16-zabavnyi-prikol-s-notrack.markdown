---
layout: post
title: "Забавный прикол с NOTRACK"
date: '2015-03-16 18:43:06'
tags:
- linux
- iptables
- conntrack
- dpi
- notrack
- pf_ring
- carbon_reductor-2
---

Валит значит на eth1 6.5гбит/с трафика, который надо анализировать (смотрим URL в http). Ничего лишнего - только psh/ack запросы. Нагрузка висит под 73%. Пробуем исключить то, что это система фильтрации напрягает проц так.

	iptables -t mangle -I PREROUTING -i eth1 -j DROP

Нагрузка всё так же висит на 73% и стала подскакивать до 75 (приближался час пик).

... прошла неделя изучения и экспериментов с pf_ring ...

# ВНЕЗАПНОЕ ОСЕНЕНИЕ

    for i in $(brctl show | egrep -o eth[0-9\.]+$); do
    	iptables -t raw -I PREROUTING -i $i -j NOTRACK
    done
 
Вуаля - нагрузка на процессор висит на уровне 1.5-2%.