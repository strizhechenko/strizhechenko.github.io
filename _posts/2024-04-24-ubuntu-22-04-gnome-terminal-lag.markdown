---
title: Тормоза в Gnome Terminal в Ubuntu 22.04
---

**TL;DR**: виновато вообще не то, на что сперва думаешь; Linux на десктопе это боль (даже для разработчиков).

Gnome-terminal начал подлагивать при каждом нажатии клавиши.

## На что грешил

- zsh ходит в интернет
- history-файл разросся
- nvidia поломала драйвера
- pyenv тормозит при каждой отрисовке промпта
- SSD помирает и поэтому плагин oh-my-zsh по отрисовке ветки git в промпте подвисает

## Средства диагностики

- отключение сети (ну вдруг какой-то флажок бы выставился и всё начало летать)
- set -x в терминале (и поиск подлагивающей команды глазами)
- tcpdump (ти ши на)
- strace на gnome-terminal в котором он же и запущен и который в итоге показывал отрисовку выхлопа strace
- переключение на /bin/sh (тоже глючил)
- iotop (в целом тишина, редкие записи jbd2)
- переключение на другой tty (CTRL-ALT-F3) (пропало)
- Google://ubuntu 22.04 gnome terminal input delay (с этого надо было начать)

Нашёл в интернете упоминания, что разработчики чего-то связанного с mutter навертели и оно попало в репы Ubuntu 22.04. Подсмотрел на рабочем ноуте, который обновляю спустя три месяца обкатки тех же версий на рабочем компе предыдущую версию #Mutter и попробовал откатиться к ней. Было нелегко, но я хотя бы задокументирую собранные грабли.

## Решение

В общем нужен файлик `/etc/apt/preferences` с содержимым:

``` yaml
Package: mutter
Pin: version 42.0-3ubuntu2
Pin-Priority: 1001

Package: mutter-common
Pin: version 42.0-3ubuntu2
Pin-Priority: 1001

Package: libmutter-10-0
Pin: version 42.0-3ubuntu2
Pin-Priority: 1001

Package: gnome-shell
Pin: version 42.0-2ubuntu1
Pin-Priority: 1001

Package: gnome-shell-common
Pin: version 42.0-2ubuntu1
Pin-Priority: 1001

Package: gir1.2-mutter-10
Pin: version 42.0-3ubuntu2
Pin-Priority: 1001

Package: gnome-remote-desktop
Pin: version 42.0-4ubuntu1
Pin-Priority: 1001
```

Оно выглядит странно, но таковы зависимости в кишках Gnome.

Далее, делаем:

``` shell
sudo apt update
sudo apt install mutter mutter-common libmutter-10-0 gir1.2-mutter-10 gnome-shell gnome-shell-common gnome-remote-desktop
```

Смотрите внимательно, чтобы эта команда не снесла чего лишнего (я в какой-то момент лишился `ubuntu-gnome-desktop` и сильно плевался).

P.S: вспомнил, кстати, зачем мне нужен побайтовый бэкап корневого раздела раз в полгода.

P.P.S: баги могут просочиться и в апдейты LTS-релиза.
