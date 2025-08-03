---
layout: post
title: "Execfile: python-аналог source в bash"
date: '2015-01-08 06:52:30'
tags:
- eval
- python
- bash
- source
- exec
- execfile
---

**Важно**: не создавайте дыр в безопасности в своих продуктах, используя execfile.

Задача: конфиг на python, со списками, диктами, и всем инструментарием питона.

``` python
x = 15
y = 'http://example.com'
z = [ 1, 2, 3, 4, 7 ]
```

Первая мысль: eval. Позже нашёл [execfile](https://docs.python.org/2/library/functions.html#execfile).

### Пример

``` python
$ cat /tmp/1
x = 15
y = [ 'exieg', 'feil' ]
$ python
Python 2.7.5 (default, Mar  9 2014, 22:15:05)
[GCC 4.2.1 Compatible Apple LLVM 5.0 (clang-500.0.68)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> execfile('/tmp/1')
>>> for i in y:
...     print i
...
exieg
feil
```
