---
layout: post
title: get lxc templetes on centos 6
date: '2015-06-12 07:34:33'
tags:
- centos
- lxc
---

По какой-то неведанной мне причине lxc в centos поставляется без template'ов. По этой причине я сделал так (а не надо было):

	git clone https://github.com/lxc/lxc
    cd lxc
    autoconf
    ./configure --prefix=/usr
    automake
    cd templates
    make install
    lxc-create -t centos -n mylxc

тупо, но более менее работает. Правильным вариантом было бы:

	yum -y install lxc-templates

