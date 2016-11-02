---
layout: post
title: "Как качать видосики с рен-тв"
date: '2015-10-03 19:51:47'
tags:
- download
- rientv
- rieptiloidy
- rtmp
- rtmpdump
- rentv
- videos
- flashgot
- video-download-helper
- savefrom
- save
---

1. Резолвим ren.cdnvideo.ru
- округляем ip до маски /16
- открываем страничку с видосиком
- запускаем

		sudo thark -c 30 -x  -n -V -i en0 -f 'dst net полученная_подсетка' | grep mp4

- находим в выводе строчку типа 

		20/159/28/841_e63b99fd23_14_360p-512.mp4
        
- выполняем вот такую шнягу:

		rtmpdump -r rtmp://ren.cdnvideo.ru/ren-vod/_definst_ -C B:0 -C Z: -C S:/та_самая_строчка -C S:BounceAPI3.0 -C N:0.000000 -C S:mp4 -y mp4:та_самая_строчка -o out.mp4
        
Я честно хз что означают все эти параметры + у меня не хотело качаться видео до тех пор пока я его не открыл браузером. Может совпадение, может ещё что. Ругалось на permission denied, мб какая-то защитка.

Ах да, всякие flashgot, VDH и прочие savefrom дружно не находили этого видео на странице.