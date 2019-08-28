---
layout: post
title: "Как настроить ccache?"
date: '2013-08-30 10:31:00'
tags:
- centos
- debian
- kernel
- ccache
---

## Установка

В репозиториях нет, поэтому

``` shell
wget http://samba.org/ftp/ccache/ccache-3.1.9.tar.gz
tar xfz ccache-3.1.9.tar.gz
cd ccache-3.1.9
./configure
make
make install
```

## Как настроить

Будем собирать ядро из под рута, так что:

``` shell
vim ~/.bashrc
mkdir ~/.ccache
```

и дописываем туда:

``` shell
export CCACHE_DIR="/root/.ccache"
export CC="ccache gcc"
export CXX="ccache g++"
export PATH="/usr/lib/ccache:$PATH
```

Выполняем

``` shell
source ~/.bashrc
ccache -M 4G
```

## Что даст

Более быструю повторную сборку ядра Linux.
