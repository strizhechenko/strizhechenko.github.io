---
layout: post
title: "Показать настройки только ethernet интерфейсов"
date: '2014-05-22 11:32:00'
tags:
- linux
- odnostrochniki
- siet_
---

Показать настройку сети, не считая ppp интерфейсы (которых на NAS'ах порой дохрена) без всяческих хитрых грепов!
ip -o -4 addr show label eth*