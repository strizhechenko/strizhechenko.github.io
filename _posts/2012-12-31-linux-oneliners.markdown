---
layout: post
title: "Однострочники в Linux"
date: '2012-12-31 02:27:00'
---

Максимально быстрая распаковка больших gzip архивов

```
sudo nice -n -19 gunzip -v -c bigarchive.gz > superbigfile.ext
```

----

[Шаблон bash-скрипта](https://github.com/carbonsoft/crab_utils/blob/templates/tmplt/tmplt_bash)

----

Выводить значение переменной в bash перед каждым действием:

``` shell
oleg@macbook:~ $ trap 'echo "VARIABLE-TRACE> \$variable = \"$variable\""' DEBUG
VARIABLE-TRACE> $variable = ""
oleg@macbook:~ $ variable=10
VARIABLE-TRACE> $variable = ""
VARIABLE-TRACE> $variable = "10"
oleg@macbook:~ $ variable=$((variable+variable)) && variable=0
VARIABLE-TRACE> $variable = "10"
VARIABLE-TRACE> $variable = "20"
VARIABLE-TRACE> $variable = "0"
```

Перечитать partition-table. Никак, пробовал:

``` shell
partprobe /dev/sda (warning : kernel failed to reread ....)
hdparm -z /dev/sda (BLKRRPART failed : device or resource busy)
blockdev -rereadpt /dev/sda (BLKRRPART failed : device or resource busy)
sfdisk -R /dev/sda (BLKRRPART failed : device or resource busy)
```

Как найти последние изменённые файлы на Linux-сервере:

``` shell
find  /app -xdev -type f -mtime -3 | egrep -v "(localtime|proc|resolv|boot|hosts|.git|/tmp/)"
```

- `-mtime 3` - количество дней в течении которых нужны изменения.
- `/app` - папка в которой происходит поиск изменений

Побайтовый бэкап системы

``` shell
mount /dev/sdc1 /mnt/backup/
dd if=/dev/sda of="/mnt/backup/system.$(date +"%Y-%m-%d").img" bs=4096
```

Конвертирование образов виртуальных машин

``` shell
sudo qemu-img convert host.qcow2 host.raw
VBoxManage convertdd test.raw test.vdi
```

Получить список IP-адресов на машине:

``` shell
ip addr | egrep -wo '([0-9]{1,3}\.*){4}/[0-9]{1,2}'
```

или

``` shell
ip -o -f "inet" addr | awk '{print $4}'
```
