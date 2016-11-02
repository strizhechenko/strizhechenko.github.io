---
layout: post
title: "Аналог source из bash в python"
date: '2015-01-08 06:52:30'
tags:
- eval
- python
- bash
- source
- exec
- execfile
---

Долго пытался найти что-то похожее, плясал полчаса с importlib, смирился и решил использовать ConfigParser и генерить достаточно сложные ini-файлы, хотя и хотелось максимальной простоты и тупо записать три переменные в духе:

	x = 15
    y = 'http://example.com'
    z = [ 1, 2, 3, 4, 7 ]
    
А утром проснулся и в голову пришла мысль об eval. Но - это опять же оставалось достаточно сложно. И тут я понял, что source в bash - built-in, так что если аналог в python и есть - вероятно тоже встроенный. Открываем доку и находим то что нам надо - [execfile](https://docs.python.org/2/library/functions.html#execfile).

### Пример

	oleg@macbook:~ $ cat /tmp/1 
    x = 15
    y = [ 'exieg', 'feil' ]
    oleg@macbook:~ $ python
    Python 2.7.5 (default, Mar  9 2014, 22:15:05) 
    [GCC 4.2.1 Compatible Apple LLVM 5.0 (clang-500.0.68)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.
    >>> execfile('/tmp/1')
    >>> for i in y:
    ...     print i
    ... 
    exieg
    feil