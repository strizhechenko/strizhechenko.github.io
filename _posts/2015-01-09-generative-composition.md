---
layout: post
title: Generative Composition
date: '2015-01-09 11:43:19'
tags:
- generative-music
- generative-composition
- music
- programming
---



Прямо ровно то о чём я давно мечтал. Хотя, по мне ближе идея мини-языка для описания музыки, что-то в духе:

``` python
bpm=115

def beat():
	if tick % 4 == 0:
    	sound(kick)
    if tick % 8 == 0:
    	sound(snare)
    if (tick + 2) % 2 == 0:
    	sound(hat)

def bass(generator):
	base_octave = 4
    distance = 2
    line = [ 12, 24, 36, 24, 12, 12, 12, 24, 36, 24, 12, 36 ]
    bassline(base_octave, distance, line)

while True:
	fork(beat())
    fork(bass(acid))
    wait
```

Хочу найти библиотеку для работы с midi в python и написать такой мини-язык. Надо бы сперва перепробовать весь софт из [статьи на википедии](http://en.wikipedia.org/wiki/Generative_music).

## Доп. Список ПО

Max/MSP, PureData, Overtone, SuperCollider, CSound, ChucK, Faust, Processing, Pixelang.
