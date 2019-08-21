---
layout: post
title: "Не работает virt-viewer через SSH с пробросом X на MacOS 10.9"
date: '2015-08-28 07:56:16'
tags:
- centos
- libvirt
- mac-os-x
- gtk-vnc
- keymaps
- keycodes
- gobject-introspection
- gnome
- xquartz
---

Чего охота:

``` shell
ssh -X root@centos_server
virt-viewer vm_name
```

Проблема №1: квадратики вместо шрифтов

``` shell
yum install dejavu-lgc-sans-fonts liberation-sans-fonts gtk-vnc-devel
```

Проблема №2: передача кривых нажатий клавиш в VM (пишем одно, передаётся другое), выдаётся ошибка:

```
(virt-viewer:21252): gtk-vnc-WARNING **: unknown keycodes `empty_aliases(qwerty)', please report to gtk-vnc-devel
```


Поставтьте в настройках vnc раскладку en-us вместо auto.
