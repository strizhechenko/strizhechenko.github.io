---
layout: post
title: "Как пользоваться rsync"
date: '2014-12-23 17:21:59'
tags:
- carbonsoft
- rsync
- crb_sync
- benchmark
---

## Стандартное поведение

Дважды скачаем с помощью rsync один файл, во второй раз он будет писаться поверх имеющегося:

``` shell
REMOTE_ISO="oleg@10.90.140.63:/devel/output/Carbon_Billing_oleg.iso"
for i in 1 2; do
		time rsync --progress "$REMOTE_ISO" Carbon_Billing_oleg.iso
done
Carbon_Billing_oleg.iso
  2940602368 100%   31.61MB/s    0:01:28 (xfer#1, to-check=0/1)

sent 30 bytes  received 2940961422 bytes  32859904.49 bytes/sec
total size is 2940602368  speedup is 1.00

real	1m29.065s
user	0m32.420s
sys	0m12.330s
Carbon_Billing_oleg.iso
  2940602368 100%   62.84MB/s    0:00:44 (xfer#1, to-check=0/1)

sent 433878 bytes  received 217014 bytes  6412.73 bytes/sec
total size is 2940602368  speedup is 4517.80

real	1m41.437s
user	0m11.340s
sys	0m3.880s
```

Во второй раз вышло даже медленее.

## Со сжатием

Добавим к копированию поверх сжатие на максимальном уровне.

``` shell
time rsync -z --compress-level 9 --progress "$REMOTE_ISO" Carbon_Billing_oleg.iso
Carbon_Billing_oleg.iso
  2940602368 100%   57.37MB/s    0:00:48 (xfer#1, to-check=0/1)

sent 433878 bytes  received 90 bytes  3892.09 bytes/sec
total size is 2940602368  speedup is 6776.08

real	1m51.406s
user	0m11.530s
sys	0m3.830s
```

Вышло ещё меделеннее. Это потому что машины находятся в локальной сети. В случае с узким каналом, сжатие ускорит процесс, но с некоторой вероятностью всё сломает. В rsync имеется баг с опцией -z, он может падать при передаче некоторых пакетов. Вероятность очень низкая, но есть, а повторное выкачивание не поможет. Это можно обойти кодом:

``` shell
rsync() {
	/usr/bin/rsync -z $@ || /usr/bin/rsync $@
}
```

## Работа с блоками

Добавим две опции:

- `--block-size=40507` - размер блока для сравнения
- `-c` - проверка checksum блоков вместо времени изменения файла.

``` shell
time rsync --block-size=40507 -c -z --compress-level 9 --progress "$REMOTE_ISO" Carbon_Billing_oleg.iso

sent 11 bytes  received 67 bytes  2.84 bytes/sec
total size is 2940602368  speedup is 37700030.36

real	0m26.553s
user	0m5.340s
sys	0m0.590s
```

### Без сжатия

В локальной сети сжатие - лишняя вычислительная нагрузка, так что отключим его:

``` shell
time rsync --block-size=40507 -c  --progress "$REMOTE_ISO" Carbon_Billing_oleg.iso

sent 11 bytes  received 67 bytes  3.32 bytes/sec
total size is 2940602368  speedup is 37700030.36

real	0m22.893s
user	0m5.170s
sys	0m0.820s
```

Согласитесь, это куда лучше чем тянуть 2.9гб целиком через scp? :)

## Carbon Sync

А теперь - тест разработки Carbon Soft для этих целей: crb_sync.

``` shell
for i in 1 2; do
	time sudo crb_sync /devel/iso_make/output/Carbon_Billing_oleg.iso oleg@10.90.1.140:/storage/iso/ &>/dev/null
done
real	1m32.571s
user	0m38.466s
sys	0m46.955s

real	0m2.039s
user	0m1.127s
sys	0m0.406s
```

Минусы - все блоки хранятся в папке рядом с файлом, поэтому размер занимаемый копируемыми файлами умножается на 2 и прогрессивно растёт по мере изменений - вся история хранится в той папке.

Плюсы - скорость работы. Когда большой файл меняется внутри незначительно, а денег на диски хватает - минусы меркнут.
