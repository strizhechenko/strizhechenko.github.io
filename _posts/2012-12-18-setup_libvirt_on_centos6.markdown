---
layout: post
title: "Сервер виртуализации Centos 6 + libvirt"
date: '2012-12-18 18:13:00'
tags:
- centos
- kvm
- libvirt
- qemu
- virtualizatsiia
- avtomatizatsiia
- ustanovka_sierviera
---

## Задача

Иметь сервер виртуализации на Centos 6.3 (qemu/kvm, с libvirt-обёрткой).Иметь возможность устанавливать виртуальные машины на основе шаблонов.Решение под катомОффтоп

### Почему я рекомендую Centos / Rhel.

Может быть сейчас ситуация уже и исправлена, но у меня случалась недавно ситуация, когда после того как на хост-системе под управлением debian 6 кончилось место на диске с хранилищем образов виртуальных машин, три из десяти работавших на тот момент машины были испорчены. Да, бэкапы это хорошо, я смог откатиться, но впечатление осталось неприятное.Что же сделал RHEL6 на работе, когда внезапно у нас случилась аналогичная проблема? Он взял и.. запаузил все виртуалки и не давал их стартануть, до тех пор, пока не освободили хотя бы немного места для работы. Ни одна из 15 критично важных для нас виртуалок не сломалась.

### Почему я советую использовать libvirt.

В комплекте с libvirt идёт множество отличных средств, вроде virsh, virt-install, позволяющих при мало-мальском знании bash всё очень удобно автоматизировать под себя. А если добавить к этому xdotool...К примеру сейчас когда мне надо установить последнюю версию Ideco ACP (инструкция) я запускаю свой скрипт:sudo installer asrи иду пить чай, кидать дротики или приставать с дебильными вопросами к коллегам. Когда я через три минуты возвращаюсь - я наблюдаю биллинговую систему с уже настроенной сетью.А всего-то комбинация bash, ping, xdotool, virsh и virt-viewer.Ну да ладно.

## Итак, что нам нужно.

### Установить всё необходимое

Всё, что нужно для виртуализации:

``` shell
yum -y install bridge-utils libvirt virt-manager bridge-utils для настройки libvirt и virt-manager
```

### Правильно настроить сеть на хост-системе

Скорее всего NetworkManager будет нам мешать:

``` shell
yum erase NetworkManager
```

Далее, нам нужен мост (bridge) в который будут добавляться виртуальные интерфейсы (vnet) создаваемых виртуальных машин.

_UPDATE_: Спасибо Nizami Akhmedov за пример для Centos.

Для примера предположим у нас на сервере виртуализации есть всего один интерфейс eth0 с IP-адресом 192.168.2.50, а конфигурационный файл интерфейса `/etc/sysconfig/network-scripts/ifcfg-eth0` выглядит следующим образом:

``` shell
DEVICE="eth0"
BOOTPROTO="static"
HWADDR="1C:6F:65:53:77:D5"
IPADDR=192.168.2.50
NETMASK=255.255.255.0
GATEWAY=192.168.2.1
ONBOOT="yes"
```

Приводим его к сделующему виду:

``` shell
DEVICE="eth0"
BOOTPROTO="static"
HWADDR="1C:6F:65:53:77:D5"
BRIDGE=br0
ONBOOT="yes"
```

Создаем `/etc/sysconfig/network-scripts/ifcfg-br0` и заполняем:

``` shell
DEVICE="br0"
TYPE=Bridge
BOOTPROTO="static"
IPADDR=192.168.2.50
NETMASK=255.255.255.0
GATEWAY=192.168.2.1
ONBOOT="yes"
```

Перезапускаем сервис:
 
``` shell
network/etc/init.d/network restart
```

Этот бридж будет внешним интерфейсом, то есть в интернет хост-система должна ходить через него. Для простейшего использования этого нам будет достаточно.

### Создайте управляемое хранилище

Чтобы использовать форматы образов кроме raw нужно будет создать управляемое хранилище. Находится оно рядом с сетевыми интерфейсами в Connection Details. Управляемое храналище параллельно позволит вам удобно наблюдать за количеством и размером жестких дисков с помощью virt-manager. (чего я не делал уже года полтора, лол). Что это даст: возможность использовать офигенные форматы qcow2 с writeback-кэшированием, что весьма нехило ускоряет дисковые операции внутри витуальных машин.

### Автоматическая установка виртуалок с использованием шаблонов

Есть такая здоровская утилита: `virt-install`. Экономит очень много времени. Пример использования:

``` shell
sudo virt-install \
  -n $NAME \
  -c $ISO \
  -r 512 \
   --vcpus=2 \
  --os-type=linux \
  --os-variant=generic24 \
   --network bridge=br0,model='e1000' \
  --network bridge=br1,model='e1000' \
  --disk path=$POOL$NAME.img,size=${SIZE:-12},format='qcow2',cache='writeback'
```

Вся автоматизация строится на получении следующих переменных: $NAME, $ISO, $POOL, $SIZE. При этом $NAME при желании можно получать из названия образа установщика/livecd ($ISO) отрезанием расширения, POOL и SIZE зашить константно. Запихать всё это дело в bash-скрипт и вызывать на манер:

``` shell
sudo vinstall centos63_livecd_dvd_1.iso
```

### Скачивание образов

Если вам нужно забирать последнюю версию дистрибутива с FTP вы можете ещё немного автоматизировать весь процесс, в результате убрав из вызова скрипта единственный параметр - образ ISO. Автоматизировать процесс скачивания и поиска последней версии помогут:

#### FTP

файл `~/.netrc`, в котором нужно указать логин и пароль для конкретного сервера:

``` shell
machine 10.0.0.150
        login itsalogin
        password itsapassword
```

#### SSH/SCP/SFTP

Авторизация по ключам, см. тулзы ssh-keygen, ssh-copy-id + отключить опцию `StrictHostKeyChecking no` в `/etc/ssh/ssh_config`, либо использовать отдельный конфига с отключенной опцией только для этой цели, указывая его для scp через параметр:

``` shell
scp -F $SSH_CONFIG ...
```

### Собственно про шаблоны то!

А есть ещё один вариант: Если настройки виртуальных машин часто повторяются, то можно использовать подстановку для переданного параметра, а шаблоны определить прямо в скрипте установщика. То есть написать что-то в духе:

``` shell
#!/bin/bash

kernel24='--os-type=linux --os-variant=generic24'
kernel26='--os-type=linux --os-variant=generic26'
echo ${!1}
```

Пример вызова:

``` shell
$ bash test.sh kernel24 --os-type=linux --os-variant=generic24
```

думаю, понятно в какую сторону копать :)

## Примеры команд:

### Ждать пока виртуальная машина не выключится


``` shell
while sudo virsh list | grep -w $NAME; do
  sleep 1
done
```

### Вывод списка папок на FTP-сервере

``` shell
ftplist()  {
       echo "ls $1" | ftp $SRV || return 1
}
```

### Скачивание файла с FTP-сервера

- STORAGE - хранилище образов
- SRV - ip адрес FTP-сервера
- $1 - полное имя ISO-образа

``` shell
download() {
        # todo проверять скачалось ли
        [ ! -d "$STORAGE" ] && exit 43
        cd $STORAGE
        echo "$1"
        if [ ! -f "${1##*/}" ]; then
                echo "cd ${1%/*}
                get ${1##*/}" | ftp $SRV || return 1
        fi
        ISO=$STORAGE/${1##*/}
        echo $ISO
        [ -f "$ISO" ] && install || exit 44
}
```
