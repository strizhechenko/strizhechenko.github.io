---
layout: post
title: "Дружим mac os x 10.9, xquartz, centos и virt-viewer"
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

	ssh -X root@centos_server
    virt-viewer vm_name

проблема №1: квадратики вместо шрифтов

    yum install dejavu-lgc-sans-fonts liberation-sans-fonts gtk-vnc-devel
    
Проблема №2: передача кривых нажатий клавиш в VM (пишем одно, передаётся другое), выдаётся ошибка:

	(virt-viewer:21252): gtk-vnc-WARNING **: unknown keycodes `empty_aliases(qwerty)', please report to gtk-vnc-devel


# ДА ПОШЛО ОНО НАХУЙ

Поставтьте в настройках vnc раскладку en-us вместо auto, и не ебите себе мозги.

До этого пытался:

    yum -y install gtk-vnc
    cd /root
    wget "https://git.gnome.org/browse/gtk-vnc/snapshot/gtk-vnc-e0910397d6ba1eca3d968c98a2105c1a7ead7fd7.tar.xz"
    git clone git://git.gnome.org/gobject-introspection
    yum -y install gnome-common cyrus-sasl cyrus-sasl-devel pygtk pygtk2-devel perl gtk-doc libffi-devel perl-Text-CSV
	cd gobject-introspection
    git checkout GOBJECT_INTROSPECTION_0_9_6
    ./autogen.sh
    make
    make install
    cd ..
	tar xf gtk-vnc-e0910397d6ba1eca3d968c98a2105c1a7ead7fd7.tar.xz 
    cd gtk-vnc-e0910397d6ba1eca3d968c98a2105c1a7ead7fd7
    ./autogen.sh
    
	