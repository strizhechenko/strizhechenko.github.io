---
layout: post
title: "Раскуриванием Join за 5 минут!"
date: '2013-06-14 07:55:00'
tags:
- bash2
- join
- obiedinieniie_failov
- primier_ispol_zovaniia
---

# Сравнение с помощью join
Команда Join на самом деле не такая уж и страшная как может показаться. Если вы ещё не умеете ей пользоваться, то расслабьтесь, налейте чаю и создайте пару файлов, например:

## file1.txt

    12 грепал
    16 грека
    24 грепом
    44 репу

## file2.txt

    11 видит
    16 грека
    45 в репе
    77 баги

# Примеры

## что есть в file1, но нет в file2

    hordecore@oleg:~$ join -a 1 -j 1 -v 1 file1.txt file2.txt
    12 грепал
    24 грепом
    44 реку

## всё, кроме общих строк обоих файлов


    hordecore@oleg:~$ join -a 2 -j 1 -v 1 file1.txt file2.txt
    11 видит
    12 грепал
    24 грепом
    44 репу
    45 в репе
    77 баг

## всё, что есть в file2, но нет в file1

    hordecore@oleg:~$ join -a 2 -j 1 -v 2 file1.txt file2.txt
    11 видит
    45 в репе
    77 баг

## только общие строки обоих файлов

    join -j 1 file1.txt file2.txt 
    16 грека грека