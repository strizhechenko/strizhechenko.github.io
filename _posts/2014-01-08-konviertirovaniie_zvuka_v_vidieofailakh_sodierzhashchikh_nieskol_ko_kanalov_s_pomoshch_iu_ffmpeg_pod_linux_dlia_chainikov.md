---
layout: post
title: "Конвертирование звука в видеофайлах, содержащих несколько каналов с помощью
  ffmpeg под linux для чайников"
date: '2014-01-08 10:32:00'
tags:
- ac3
- audio
- channel
- convert
- dsa
- dts
- ffmpeg
- libmp3lame
- mkv
- mp3
- stream
- video
---

## Исходные данные

Имеем:

- Телек LG который не знает что такое DTS DSA и знать не хочет (я тоже), проявляется в виде отсутствия звука в большинстве mkv-файлов.
- MKV-файл под 21Gb весом.
- Желание посмотреть индийского терминатора.
- Ubuntu 10.04 с старым ffmpeg

Действия:

``` shell
mkdir -P ~/GIT
git clone https://github.com/FFmpeg/FFmpeg ~/GIT/FFmpeg
cd ~/GIT/FFmpeg
sudo apt-get install libmp3lame libmp3lame-dev
./configure --enable-libmp3lame
make -j 3
sudo make install
ffmpeg -i /media/hdd/Endhiran.mkv -map 0:0 -map 0:1 -map 0:3 -map 0:4 -c:v copy -c:a:0 ac3 -b:a:0 128k -c:s copy /media/hdd/output.mkv
```
## Пояснения

Для того чтобы разобраться что и как с этими map делать, для начала стоит просмотреть свойства файла:

```
ffmpeg -i Endhiran.mkv 2>&1  | grep  Stream

Stream #0:0(eng): Video: h264 (High), yuv420p(tv, bt709), 1920x816 [SAR 1:1 DAR 40:17], 24 fps, 24 tbr, 1k tbn, 48 tbc (default)
Stream #0:1(rus): Audio: dts (DTS), 48000 Hz, 5.1(side), fltp, 768 kb/s (default)
Stream #0:2(tam): Audio: dts (DTS), 48000 Hz, 5.1(side), fltp, 768 kb/s
Stream #0:3(rus): Subtitle: subrip (default)
Stream #0:4(rus): Subtitle: subrip
Stream #0:5(eng): Subtitle: subrip
```

перечисляем с ключом -map то, что хотим оставить.

Иными словами:

```
-map 0:0 -map 0:1 -map 0:3 -map 0:4
```

Означает что я хочу оставить в результате:
```
Stream #0:0(eng): Video: h264 (High), yuv420p(tv, bt709), 1920x816 [SAR 1:1 DAR 40:17], 24 fps, 24 tbr, 1k tbn, 48 tbc (default)
Stream #0:1(rus): Audio: dts (DTS), 48000 Hz, 5.1(side), fltp, 768 kb/s (default)
Stream #0:3(rus): Subtitle: subrip (default)
Stream #0:4(rus): Subtitle: subrip
```

```
-c:v copy-c:s copy
```

означает, что я не имею никаких претензий к видео и субтитрам и пусть они остаются такими как есть.

```
-c:a:0 ac3 -b:a:0 128k
```
означает, что от аудио я хочу чтобы оно стало ac3 с битрейтом 128k.

Единственное, чего я не понял - это нумерация аудиоканалов при указании кодеков, а именно почему 0, а не 1, если 0 - это видео.
