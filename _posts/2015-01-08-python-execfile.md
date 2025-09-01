---
layout: post
title: "Execfile: python-аналог source в bash"
date: 2015-01-08 06:52:30
tags:
  - eval
  - python
  - bash
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

``` shell
$ cat /tmp/1
x = 15
y = [ 'exec', 'file' ]
```
``` python
>>> execfile('/tmp/1')
>>> for i in y:
...     print i
...
exec
file
```

## 10 лет спустя

По-моему лучше уж как-то стандартными импортами воспользоваться. Дать файлу расширение `.py`., импортировать целиком модуль, например `import config` и использовать его как объект. Если он находится за пределами проекта, порешать это через `PYTHONPATH=/tmp/` (один совет лучше другого, не делайте так).

[Держите секреты в vault, из vault пихайте в переменные окружения](https://12factor.net/config), читайте их оттуда.