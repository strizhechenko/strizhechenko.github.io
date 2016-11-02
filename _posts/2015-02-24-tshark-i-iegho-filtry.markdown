---
layout: post
title: Tshark и его фильтры
date: '2015-02-24 09:26:24'
tags:
- tshark
- filters
- tcpdump
---

Фильтров бывает три:
- display - что отображать из того что наловлено
- capture - что ловить
- output - что отображать из того что решили отображать

Иными словами:

	tshark -n -i eth1 tcp -R "tcp.flags.push==1"

здесь имеем два фильтра:

capture

	tcp

и display

	-R tcp.flags.push==1

output можно юзать следующим образом:

	tshark -n -i eth1 tcp -R "tcp.flags.push==1" -Tfields -e tcp.request.method

он позволяет сформировать формат вывода, почти как printf.