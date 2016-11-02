---
layout: post
title: "Как готовить rsync"
date: '2014-12-23 17:21:59'
tags:
- carbonsoft
- rsync
- crb_sync
- zamier
---

Попробуем просто дважды скормить rsync один файл, второй раз он будет писаться поверх имеющегося:

	oleg@oleg:/storage/iso$ for i in 1 2; do time rsync --progress oleg@10.90.140.63:/devel/output/Carbon_Billing_oleg.iso Carbon_Billing_oleg.iso; done
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

Как видим, во второй раз вышло даже медленее. Теперь попробуем добавить к копированию поверх - сжатие на максимальном уровне.

    oleg@oleg:/storage/iso$ time rsync -z --compress-level 9 --progress oleg@10.90.140.63:/devel/output/Carbon_Billing_oleg.iso Carbon_Billing_oleg.iso
    Carbon_Billing_oleg.iso
      2940602368 100%   57.37MB/s    0:00:48 (xfer#1, to-check=0/1)

    sent 433878 bytes  received 90 bytes  3892.09 bytes/sec
    total size is 2940602368  speedup is 6776.08

    real	1m51.406s
    user	0m11.530s
    sys	0m3.830s

Даже ещё меделеннее вышло. Но: это потому что мы находимся в локальной сети с сервером с которого я тяну iso образ. В случае с выкачиванием с значительно удалённого сервера - это значительно ускорит процесс... с некоторой вероятностью, так как в rsync имеется баг с опцией -z, благодаря которому он падает при передаче некоторых пакетов (вероятность не такая уж высокая, но есть, при этом повторное выкачивание не поможет), так что можно делать код в духе:

	rsync() {
    	/usr/bin/rsync -z $@ || /usr/bin/rsync $@
    }

А теперь добавим к этому две волшебные опции: --block-size и -c. Первая указывает размер блока для сравнения, вторая - заставляет проверять checksum блоков вместо времени изменения файла.

    oleg@oleg:/storage/iso$ time rsync --block-size=40507 -c -z --compress-level 9 --progress oleg@10.90.140.63:/devel/output/Carbon_Billing_oleg.iso Carbon_Billing_oleg.iso

    sent 11 bytes  received 67 bytes  2.84 bytes/sec
    total size is 2940602368  speedup is 37700030.36

    real	0m26.553s
    user	0m5.340s
    sys	0m0.590s
    
Как я уже говорил, в локальной сети сжатие - лишняя вычислительная нагрузка, так что отключим его:

    oleg@oleg:/storage/iso$ time rsync --block-size=40507 -c  --progress oleg@10.90.140.63:/devel/output/Carbon_Billing_oleg.iso Carbon_Billing_oleg.iso

    sent 11 bytes  received 67 bytes  3.32 bytes/sec
    total size is 2940602368  speedup is 37700030.36

    real	0m22.893s
    user	0m5.170s
    sys	0m0.820s
    
Согласитесь, это куда лучше чем тянуть 2.9гб целиком через scp? :)

А теперь - тест нашего собственного жуткого монстра для этих целей: crb_sync.

	[oleg@10.90.140.63  ~]$ time sudo crb_sync /devel/iso_make/output/Carbon_Billing_oleg.iso oleg@10.90.1.140:/storage/iso/ &>/dev/null

    real	1m32.571s
    user	0m38.466s
    sys	0m46.955s

А теперь, ничего не изменяя:

    [oleg@10.90.140.63  ~]$ time sudo crb_sync /devel/iso_make/output/Carbon_Billing_oleg.iso oleg@10.90.1.140:/storage/iso/ &>/dev/null

    real	0m2.039s
    user	0m1.127s
    sys	0m0.406s

Есть у него, конечно и свои минусы - все блоки он хранит в папке рядом с файлом, так что размер занимаемый копируемыми файлами умножается на два и прогрессивно растёт по мере изменений - вся история хранится в той папке. Но когда скорость работы важнее дешёвого места на диске, а большой файл меняется внутри незначительно - он оказывается в самый раз.