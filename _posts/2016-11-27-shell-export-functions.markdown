---
layout: post
title: Странности с экспортом в bash
---

## Я ничего не понимаю в bash

strizhechenko: Берём функцию:

x() {
	local y
	y=“something”
	echo $y
	return 0
}

export -f x

bash -c x

упадёт с сегфолтом!

strizhechenko: Почему запуск экспортированной функции с локальной переменной обламывается - не знаю, но это делает меня грустить.

strizhechenko: Код разврата: 139.
Надо бы почитать на эту тему.

strizhechenko: Второй момент который меня сводит с ума:

export timeout=10
export filter=“tcp dst port 443”
При использовании в X() timeout есть filter нет
