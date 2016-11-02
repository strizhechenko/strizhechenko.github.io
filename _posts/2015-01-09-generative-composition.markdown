---
layout: post
title: Generative Composition
date: '2015-01-09 11:43:19'
tags:
- generative-music
- generative-composition
- music
- programming
- genacid
---

http://en.wikipedia.org/wiki/Generative_music

Прямо ровно то о чём я давно мечтал. Хотя, по мне ближе идея мини-языка для описания музыки, что-то в духе:

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

Наверное правильным вариантом было бы найти хорошую библиотеку для работы с midi в python и написать такой мини-язык самостоятельно, но сперва - попробую весь софт с wikipedia из статьи и напишу на него рецензии.

Что забавно - если ударюсь в этот жанр и всё пойдёт хорошо - мне даже не надо менять название музыкального проекта - genacid итак звучит как **gen**erative **acid**.