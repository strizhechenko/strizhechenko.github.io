---
layout: post
title: "Выкачиваем музыку из постов трэк-паблика вконтакте. Не ищем лёгких путей."
date: '2014-01-12 09:34:00'
---

К сожалению мне лень писать код для получения количества постов, сдвигать offset, так что обойдёмся первыми 100 постами.

<a name="more"></a>

## скрипт parse_wall.py
#!/usr/bin/python
import json
from pprint import pprint
pprint(json.load(open('wall.json')))

## Скачиваем стенку через API
curl "https://api.vk.com/method//wall.get?domain=newbeatmusic&count=100" > wall.json

## Получаем список ссылок на mp3
./parse_wall.py | grep -o http://.*.mp3 | sort -uДальше остаётся только ловкость рук/wget/итд.