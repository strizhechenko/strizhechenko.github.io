---
layout: post
title: "Парсим xml-дамп библиотеки iTunes с помощью Python и анализируем с помощью
  bash"
date: '2013-11-11 17:42:00'
tags:
- bash2
- itunes_library
- python
- xml
- analiz
---

Ииии бинго, статистика моей музыкальной библиотеки готова.

## Можно скриптами можно полюбоваться здесь:

[https://github.com/strizhechenko/itunes-library-xml2plaintext](https://github.com/strizhechenko/itunes-library-xml2plaintext)

## Результат анализа:
- Общее количество артистов в библиотеке: 690
- А если исключить разнописания, останется всего 649
- Песен у них - 7463
- Но это ложь - песни дублируются, по разному пишутся итд. На самом деле их около 7216

Теперь немного фана. Исходя из того что в среднем альбом стоит 100 рублей, посчитаем сколько денег понаворовано. Будем считать что в альбоме в среднем 10 песен, и одна стоит 10 рублей 

Итого мы напиратили/напокупали музыки на 74630 рублей.

А теперь представим что мы злобные пираты и сидели на раздаче, и пока качали сами - с нас стянули в три раза больше. Тогда, по подсчётам копирастичных товарищей мы нанесли ущерб размером 298520 рублей

## Ну и топ30 по количеству трэков:

571 front 242
558 coil
413 leaether strip
375 nocturnal emissions
337 die krupps
304 einstuerzende neubauten
284 nitzer ebb
236 and one
234 vargr
227 portion control
211 welle erdball
190 depeche mode
160 asplit second
158 absolute body control
157 nordvargr
142 folkstorm
126 deutschamerikanischefreundschaft
122 masonna
106 toroidh
106 orange sector
81 à;grumh...
75 bloodsucking zombies from outer space
74 clock dva
72 mz412
72 individual totem
66 skinny puppy
65 pouppee fabrikk
63 bigod 20
56 jäger 90
52 morgue
51 click click

Из чего видно, что над тэгами стоит поработать :)

## А также вещи в единичном количестве

1 nancy sinatra
1 astrovamps
1 Astrogenic Hallucinating
1 art &amp; technique
1 artefactum &amp; horologium
1 apoptose
1 annedrogyness
1 alvanoto
1 allerseelen
1 agrezzior
1 agonised by love
1 adrian borland
1 ad:key
1 c.c.c.c.
1 bodyfarm
1 delkom
1 control zone
1 diorama
1 em:ko
1 inorganic
1 legionarii
1 lokomotiv
1 noises of russia
1 Nouvelles Lectures Cosmopolites
1 pinselliest!
1 starindustry
1 t.a.n.k.
1 pink turtle

И чёрт побери, я не зря это набросал, я нашёл чертовски шикарных Pink Turtle!!!

Ну и чуток питон подтянул, да и XML по человечьи парсить научился.