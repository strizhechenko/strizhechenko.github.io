---
layout: post
title: "Простые оптимизации кода на python 2.6"
date: '2015-10-02 11:17:10'
---

- cProfile, pydot, graphviz
- %timeit
- не создавайте объекты лишний раз (x = x | y) != ( x |= y)
- map имеет преимущество перед for обычно только в случае использования builtin в качестве функции. Lambda обычно лучше развернуть в цикл/списковое выражение.
- если уж совсем поехавшие, можно избавляться от лишних вызовов функций
- просто старайтесь лишний раз чего-нибудь не делать, один filter(built-in check, list) в цикле может оказаться полезным.

		diff = set()
        for item in orig_set():
        	if something(item):
                diff.add(foo(item))
        orig_set.update(diff)
        return orig_set
 
 обычно более выгодно, чем, т.к. при больших объёмах вставка set.add() слегка замедляется (привет проверка на уникальность):
 
 		diff = orig_set.copy()
        for item in orig_set:
            if something(item):
            	diff.add(foo(item))
        return diff
     
# Регулярки в функциях
 
Вероятно вы компилируете регулярное выражение несколько раз (а возможно даже очень много раз) в рамках функции/цикла. Вынесите компиляцию туда, где она выполнится один раз.

1

    def foo(str):
        return re.match(reg, string) 

2

    def foo(str):
        r = re.compile(reg)
        return r.match(str)
    

3

	r = re.compile(reg)
    def foo(str):
        return r.match(str)
