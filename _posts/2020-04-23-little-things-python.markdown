---
title: Мелочь, которой мне не хватает в Python: first(iter)
---

Эдакое first or none для +/- сложного поиска в дикте.

Есть код вида:

``` python
mydict_new = dict()
for key, value in mydict.items():
    сложная логика чтобы уместиться в одну строчку
    flag = False
    не один вложенный цикл:
        if очень сложное условие, возможно не одно:
            mydict_new[как бы key, но не совсем] = как бы value, но не совсем
            flag = True
    if not flag:
        mydict_new[чуток другой key] = чуток другой value
return mydict_new
```

Хочу что-то среднее между any и next чтобы не ходить далеко по итератору, но и ошибки не обрабатывать исключениями. Эдакий first().

``` python
[in  1] first(i for i in range(10) if i > 5)
[out 1] 6
[in  2] first(i for i in range(10) if i > 15)
[out 1] None
```

Так бы код можно было отрефакторить до:

``` python
mydict_new = dict()
for key, value in mydict.items():
    сложная логика чтобы уместиться в одну строчку
    mydict_new[как бы key, но не совсем] = first(some_func(a, value) for a in не один вложенный цикл if очень сложное условие) or чуток другой value
return mydict_new
```
