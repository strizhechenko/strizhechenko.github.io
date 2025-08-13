---
layout: post
title: "Как скачать видео с сайта рен-тв"
date: '2015-10-03 19:51:47'
tags:
- download
- rientv
- rtmp
- rtmpdump
- rentv
- videos
- flashgot
- video-download-helper
- savefrom
- save
---

1. `dig ren.cdnvideo.ru A`
2. округляем ip до маски `/16`
3. открываем страничку с видео
4. запускаем `sudo thark -c 30 -x  -n -V -i en0 -f 'dst net полученная_подсеть' | grep mp4`
5. находим в выводе строчку типа: `20/159/28/841_e63b99fd23_14_360p-512.mp4`
6. выполняем:

rtmpdump -r rtmp://ren.cdnvideo.ru/ren-vod/_definst_ \
	-C B:0 \
	-C Z: \
	-C S:/та_самая_строчка \
	-C S:BounceAPI3.0 \
	-C N:0.000000 \
	-C S:mp4 \
	-y mp4:та_самая_строчка \
	-o out.mp4

Я честно хз что означают все эти параметры.

У меня не хотело качаться видео до тех пор пока я его не открыл браузером. Может совпадение, может ещё что. Ругалось на permission denied, мб какая-то защита.

Плагины к браузеру вроде flashgot, VDH и прочие savefrom дружно не находили этого видео на странице.
