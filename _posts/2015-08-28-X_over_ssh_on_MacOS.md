---
layout: post
title: "SSH с пробросом X на MacOS"
date: '2015-08-28 07:56:16'
tags:
- centos
- libvirt
- mac-os-x
- gtk-vnc
- keymaps
- keycodes
- gnome
- xquartz
---

Чего охота:

``` shell
ssh -X root@centos_server
virt-viewer vm_name
```

## Квадратики вместо шрифтов

Решается на стороне сервера.

``` shell
yum install dejavu-lgc-sans-fonts liberation-sans-fonts gtk-vnc-devel
```

## Передача нажатий клавиш в VM некорректна

Пишем одно, передаётся другое, выдаётся ошибка:

```
(virt-viewer:21252): gtk-vnc-WARNING **: unknown keycodes `empty_aliases(qwerty)', please report to gtk-vnc-devel
```

Поставтьте в настройках vnc раскладку en-us вместо auto.

## Проброс X сломался после обновления на High Sierra или Mojave

Дано:

- XQuartz установленный через brew cask
- переехал с bash на zsh

### untrusted X11 forwarding setup failed: xauth key data not generated

Одна из первых рекомендаций с stackoverflow:

```
➜  ~ xauth generate :0
xauth:  file /Users/oleg/.Xauthority does not exist
xauth: (argv):1:  unable to open display ":0".
```

### Временный хак

Запускаем XQuartz вручную. Ставим его в фокус, выбираем в меню - программы - терминал, из этого терминала ssh -X -C servername чудесно работает и открывает всё что нужно.

### Как сделать его постоянным

Сравнить окружение в этих терминалах. Пробовал:

``` shell
export DISPLAY=:0
export X11_PREFS_DOMAIN="org.macosforge.xquartz.X11"
```

Не помогло.

### Примечания

Если в терминале xquartz (xterm) запустить zsh - проброс X'ов тоже отваливается.

### Решение

В файл ~/.ssh/config вставляем:

``` shell
Host *
    XAuthLocation /opt/X11/bin/xauth
```
