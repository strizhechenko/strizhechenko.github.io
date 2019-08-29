---
layout: post
title: "Замеры egrep и fgrep"
date: '2013-10-03 04:43:00'
tags:
- egrep
- fgrep
- grep
---

Задача намеренно искусственная. Мы изучаем, как правильнее грепать несколько паттернов при разных объёмах файлов.

## Дано

Текстовый файл с числами от 1000000 до 9999999. **Задача** - найти среди них красивые номера.

Образ решения в виде:

``` shell
for x ...
    for y ..
        grep $x$y$y$y$ big_list_file.txt
```

```
$ wc -l megalist 
9000000 megalist
$ du -sh megalist 
69M megalist
```

## Варианты

Использование конструкции вида

``` shell
fgrep $mask1 megalist
fgrep $mask2 megalist
```

против

``` shell
egrep "($mask1|$mask2)" big_list_file.txt
```

## Если шаблонов 2

### fgrep

``` shell
#!/bin/bash

for ((x=0; x<10; x++)); do
    for ((y=0; y<10; y++))
        if [ "$x" != "y" ]; then
            fgrep "$x$y$y$y$y$y$y" megalist 
            fgrep "$y$y$y$y$y$y$x" megalist 
        fi
    done
done
```

Скорость работы:

```
real 0m11.420s
user 0m9.670s
sys 0m2.790s
```

### egrep

```
#!/bin/bash

for ((x=0; x<10; x++)); do
    for ((y=0; $y<10; y++)); do
        if [ "$x" !="$y" ]; then
            egrep "($x$y$y$y$y$y$y|$y$y$y$y$y$y$x)" megalist
        fi
    done
done
```

Скорость:

```
real 0m5.682s
user 0m4.740s
sys 0m1.440s
```

### python

```
#!/usr/bin/env python

import re

regvar=r'^(\d)\1{6}'
for num in range(1000000, 9999999):
    if re.search(regvar, str(num)):
        print num
```

```
real 0m18.390s
user 0m18.240s
sys 0m0.110s
```

### fgrep можно ускормить

Поскольку в случае с fgrep каждому витку цикла соответствует одно число на каждый fgrep можно его ускорить на первых числах - добавить ключ -m1, то есть до первого вхождения.

``` shell
#!/bin/bash

for ((x=0; x<10; x++)); do
    for ((y=0; y<10; y++))
        if [ "$x" != "y" ]; then
            fgrep -m1 "$x$y$y$y$y$y$y" megalist 
            fgrep -m1 "$y$y$y$y$y$y$x" megalist 
        fi
    done
done
```
