---
layout: post
title: "Замеры egrep и fgrep"
date: '2013-10-03 04:43:00'
tags:
- egrep
- grep
- sravnieniie_skorosti
- shablony
---

## Внимание!
Ни в коем случае не делайте так для того чтобы получить номера, для этого достаточно сделать echo. Grepы используются только для оценки того, как правильно грепать несколько паттернов при разных объёмах файлов.

## Имеем:
Текстовый файл с числами от 1000000 до 9999999.
Задача - найти среди них красивые номера.
Образ решения в виде for x ... for y ... grep $x$y$y$y$ big_list_file.txt

oleg@oleg:~/GIT/gold_numbers$ wc -l megalist 
9000000 megalist
oleg@oleg:~/GIT/gold_numbers$ du -sh megalist 
69M megalist

## Сравним:
Использование конструкции вида

fgrep $mask1 big_list_file.txt
fgrep $mask2 big_list_file.txt

против

egrep "($mask1|$mask2)" big_list_file.txt

## На двух шаблонах

### fgrep

oleg@oleg:~/GIT/gold_numbers$ cat brilliant_xyyyyyy_and_yyyyyyx.sh 
#!/bin/bash
for ((x=0;$x
 for ((y=0;$y
  if [ "$x" != "y" ]; then
   fgrep $x$y$y$y$y$y$y megalist 
   fgrep $y$y$y$y$y$y$x megalist 
  fi
 done
done

oleg@oleg:~/GIT/gold_numbers$ time ./brilliant_xyyyyyy_and_yyyyyyx.sh >/dev/null
real 0m11.420s
user 0m9.670s
sys 0m2.790s

### egrep
#!/bin/bashfor ((x=0;$x<10;x++)); do="" for="" ((y="0;$y&lt;10;y++));" if="" [="" "$x"="" !="y" ];="" then="" egrep="" "($x$y$y$y$y$y$y|$y$y$y$y$y$y$x)"="" megalist ="" fi="" donedoneoleg@oleg:~="" git="" gold_numbers$="" time="" .="" brilliant_xyyyyyy_and_yyyyyyx.sh="">/dev/nullreal 0m5.682suser 0m4.740ssys 0m1.440s</10;x++));>Бонус - python + re.search vs bash + fgrep
oleg@oleg:~/GIT/gold_numbers$ cat python_re.py 
#!/usr/bin/python
import re
regvar=r'^(\d)\1{6}'
for num in range(1000000,9999999):
 if re.search(regvar, str(num)):
  print num
oleg@oleg:~/GIT/gold_numbers$ time ./python_re.py >/dev/nullreal 0m18.390suser 0m18.240ssys 0m0.110s

## Дополнительное ускорение fgrep
Поскольку в случае с fgrep каждому витку цикла соответствует одно число на каждый fgrep можно его ускорить на первых числах - добавить ключ -m1, то есть до первого вхождения.#!/bin/bashfor ((x=0;$xoleg@oleg:~/GIT/gold_numbers$ time ./brilliant_xyyyyyy_and_yyyyyyx.sh >/dev/nullreal 0m6.730suser 0m5.710ssys 0m1.830segrep конечно не перегнали, но ускорились существенно. Жаль, что к egrep эту опцию не прикрутить :)