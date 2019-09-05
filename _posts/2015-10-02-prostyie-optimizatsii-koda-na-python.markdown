---
layout: post
title: "Простые оптимизации кода на python 2.6"
date: '2015-10-02 11:17:10'
---

Сперва используйте штатные средства, найдите бутылочное горлышко и оптимизируйте его:

- cProfile, pydot, graphviz
- %timeit
- не создавайте объекты лишний раз (x = x | y) != ( x |= y)
- map имеет преимущество перед for обычно только в случае использования builtin в качестве функции. Lambda обычно лучше развернуть в цикл/списковое выражение.
- если уж совсем поехавшие, можно избавляться от лишних вызовов функций
- просто старайтесь лишний раз чего-нибудь не делать, один filter(built-in check, list) в цикле может оказаться полезным.

## Работа с множествами

При больших объёмах вставка set.add() слегка замедляется из-за проверки на уникальность.

``` python
diff = set()
for item in orig_set():
	if something(item):
		diff.add(foo(item))
orig_set.update(diff)
return orig_set
```

обычно более выгодно, чем

``` python
diff = orig_set.copy()
for item in orig_set:
    if something(item):
		diff.add(foo(item))
return diff
```
