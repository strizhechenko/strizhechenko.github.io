---
title: Профилирование Linux-бинарей под MacOS
---

Кратко: куча проблем, виртуалки, страдания и ужас. Возможно со временем что-то и решу и сделаю лучше в текущем процессе.

## Дано

- gprof нет под MacOS
- gprof не умеет в частичный профайлинг
- valgrind не хочет устанавливаться через brew
- со сборкой valgrind из сырцов чот встрял на 10 минут, дальше лень стало
- clion **вроде** не имеет встроенных средств профилирования. Поверхностно прочитал, что они буквально месяц-полтора назад добавили поддержку valgrind, но как там дела с callgrind - не знаю.
- gprof2dot падает с ошибкой при попытке скушать callgrind.out
- gprof2dot больше не поддерживает python 2.6 который в CentOS 6 (целевая система) стоит по умолчанию.

## Найти

Способ отпрофилировать отдельный кусок кода. Полное профилирование процесса приводит к тому, что 95% времени занимается инициализация тестовых данных, на которую при профилировании алгоритма поиска глубоко пофиг.

## Текущий процесс

Ставим valgrind + valgrind-devel на CentOS-виртуалку.

В исходники добавляем

``` c
#ifdef CALLGRIND
#include <valgrind/callgrind.h>
#endif

...

int main(void)
{
	setup();
#ifdef CALLGRIND
	CALLGRIND_START_INSTRUMENTATION;
#endif
	performance_test_main();
#ifdef CALLGRIND
	CALLGRIND_STOP_INSTRUMENTATION;
	CALLGRIND_DUMP_STATS;
#endif
	teardown();
	return 0;
}
```

ifdef штука стрёмная, но пока мы хотим иметь возможность эти тесты запустить у себя на маке чтобы прикинуть порядки времени выполнения. Ситуации когда это надо - девелопишь в оффлайне, доступа к VM нет, а больше нечего делать.

Собираем c `-DCALLGRIND` и запускаем всё там.

Забираем `callgrind.out.$pid` к себе на машину с MacOS по scp, где нас ждёт установленный командой `brew install qcachegrind` qcachegrind, который как kcachegrind, но qt.

Кормим его qcachegrind'у:

``` shell
qcachegrind callgrind.out.$pid
```
