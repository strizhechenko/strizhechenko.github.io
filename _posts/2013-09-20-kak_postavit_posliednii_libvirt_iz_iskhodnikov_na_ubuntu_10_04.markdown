---
layout: post
title: "Как поставить последний libvirt из исходников на ubuntu 10.04"
date: '2013-09-20 04:26:00'
---

Это решит пару проблем в будущем, например
I/O error : Attempt to load network entity http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd

sudo apt-get install w3c-dtd-xhtml libdevmapper-dev

mkdir -p ~/GIT/
cd ~/GIT/
git clone git://libvirt.org/libvirt.git
cd libvirt
./autogen.sh
make
make install