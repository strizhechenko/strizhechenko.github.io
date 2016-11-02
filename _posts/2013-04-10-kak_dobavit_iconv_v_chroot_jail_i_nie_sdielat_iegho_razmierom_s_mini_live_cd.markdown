---
layout: post
title: "Как добавить iconv в chroot jail и не сделать его размером с мини LiveCD"
date: '2013-04-10 01:45:00'
tags:
- carbon_reductor
- centos
- chroot_jail
- iconv
- kodirovki
- obriezaniie_locale_archive
- razmier_iconv
---

Всё началось с того, что я добавлял в [Carbon Reductor](http://carbonsoft.ru/products/carbon-reductor-1-0) возможность исправлять на лету косяки с кодировкой кириллических доменов, достаточно часто встречающиеся в списках URL с [zapret-info.gov.ru](http://zapret-info.gov.ru/), использовал для этого iconv. И тут внезапно я заметил, что архив вместо 11мб стал весить 80, а это для tar'ника с chroot-jail'ом таки много!

Рецепт достаточно прост - скорее всего вам нужна поддержка 5-6 кодировок максимум, поэтому не стоит копировать всё подряд. А обрезание locale.archive позволит сэкономить ещё больше места. Итак, как это сделать на CentOS 6.3:

### Добавление только нужных кодировок
Вместо cp -arup /usr/lib64/gconv/ ./chroot/usr/lib64/gconvПоступаем немного аккуратнее:cp -aup /usr/lib64/gconv/gconv* ./chroot/usr/lib64/gconv/cp -aup  /usr/lib64/gconv/KOI8-R* ./chroot/usr/lib64/gconv/cp -aup  /usr/lib64/gconv/UTF-*  ./chroot/usr/lib64/gconv/cp -aup  /usr/lib64/gconv/UNICODE.so  ./chroot/usr/lib64/gconv/cp -aup  /usr/lib64/gconv/CP1251.so  ./chroot/usr/lib64/gconv/В результате чего экономим 7мб места. Но это мелочи по сравнению со следующим шагом.

### Генерация locale.archive без ненужных локалей
cd /usr/lib/locale/cp locale-archive locale-archive.backuplocaledef --list-archive | grep -v -e "en_US" -e "de_DE" -e "en_GB" -e "^ru*" | xargs localedef --delete-from-archivemv locale-archive locale-archive.tmpltbuild-locale-archivedu -sh locale-archive# profit!cp locale-archive ./chroot/usr/lib/locale/locale-archivemv locale-archive.backup locale.archiveВ результате мы экономим...[root@localhost locale]# du -sh *7,2M locale-archive95M locale-archive-backup0 locale-archive.tmpl87мб места! В случае, если этот chroot jail будут часто скачивать, а iconv используется только для перегона из cp1251 или koi8-r в UTF-8, то это сэкономит суммарно достаточно много времени скачивающих :)