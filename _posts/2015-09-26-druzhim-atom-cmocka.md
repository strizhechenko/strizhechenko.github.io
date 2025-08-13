---
layout: post
title: "Дружим Atom и cmocka"
date: '2015-09-26 13:36:46'
tags:
- c
- bash
- shell
- unittest
- cmocka
- atom-editor
- atom-script
---

## Начало

Я решил покрыть свой C-код юнит-тестами, хотя бы минимально. Выбрал Cmocka.

В atom для запуска программ я использую atom-script. Он примитивен, на C-файлы запускает `gcc` и выполняет результат сборки. Передача параметров `gcc` через atom-script не работает. А **для сборки тестов необходима явная линковка с cmocka**, т.е. нужно передать gcc параметр `-lcmocka`.

Можно прописать таргет в Makefile, есть плагин make-runner-panel, но он неудобен.

А хочется поведение почти как у nosetests, что же делать?

## Суперкостыль

Пишем run_tests.sh

``` shell
#!/bin/bash

mkdir -p /tmp/tests/
for test in tests/*.c; do
        bin=/tmp/${test%.c}
        rm -f $bin
        gcc $test -lcmocka -o $bin
        echo $bin
        $bin
done
```

После этого жахаем `cmd + shift + i`, прописываем в поле command: `./run_tests.sh`, выполняем `chmod a+x run_tests.sh`

Получается следующее:

![](/content/images/2015/09/--------------2015-09-26---18-36-32.png)

При большом желании можно немного поменять формат вывода текста, но это уже на вкус и цвет.

## Минусы cmocka

Каждый тест требует:

``` c
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>
```

без `setjmp` cmocka работать не хочет вообще ни в какую.
