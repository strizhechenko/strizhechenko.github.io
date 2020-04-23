---
title: Мелочь, которой мне не хватает в Python - first(iter)
---

Эдакое first or none для +/- сложного поиска в дикте.

Есть код вида:

``` python
mydict_new = dict()
for key, value in mydict.items():
    flag = False
    for a in something_else():
        if condition:
            mydict_new[key] = func2(value, a)
            flag = True
    if not flag:
        mydict_new[key] = func2(value)
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
    mydict_new[func] = first(func2(value, a) for a in somthing_else() if condition) or func2(value)
return mydict_new
```
