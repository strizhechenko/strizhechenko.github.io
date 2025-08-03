---
layout: post
title: "Сохраняем chroot jail небольшими. Iconv"
date: '2013-04-10 01:45:00'
tags:
- chroot_jail
- iconv
---

Всё началось с того, что я добавил в chroot-jail в своём проекте `iconv` и внезапно архив вместо 11мб стал весить 80. А это довольно много. Если Вам нужна поддержка 5-6 кодировок максимум, не стоит копировать всё подряд, а обрезание locale.archive позволит сэкономить ещё больше места. Как это сделать на CentOS 6.3:

## Добавление только нужных кодировок

Вместо 

``` bash
cp -arup /usr/lib64/gconv/ ./chroot/usr/lib64/gconv
```

Поступаем немного аккуратнее:

``` bash
cp -aup /usr/lib64/gconv/gconv* ./chroot/usr/lib64/gconv/
cp -aup  /usr/lib64/gconv/KOI8-R* ./chroot/usr/lib64/gconv/
cp -aup  /usr/lib64/gconv/UTF-*  ./chroot/usr/lib64/gconv/
cp -aup  /usr/lib64/gconv/UNICODE.so  ./chroot/usr/lib64/gconv/
cp -aup  /usr/lib64/gconv/CP1251.so  ./chroot/usr/lib64/gconv/
```

В результате чего экономим 7мб места. Но это мелочи по сравнению со следующим шагом.

## Генерация locale.archive без ненужных локалей

``` bash

cd /usr/lib/locale/
cp locale-archive locale-archive.backup
localedef --list-archive \
	| grep -v -e "en_US" -e "de_DE" -e "en_GB" -e "^ru*" \
	| xargs localedef --delete-from-archive
mv locale-archive locale-archive.tmplt
build-locale-archive
cp locale-archive ./chroot/usr/lib/locale/locale-archive
mv locale-archive.backup locale.archive
```

В результате мы экономим...

``` bash
[root@localhost locale]# du -sh *
7,2M locale-archive
95M locale-archive-backup
0 locale-archive.tmpl
```

87мб места!
