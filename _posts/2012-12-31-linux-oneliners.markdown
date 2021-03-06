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

## Выводить значение переменной в bash перед каждым действием:

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

## Показывать в режиме bash -x номер выполняемой строки:

``` shell
PS4="$PS4 line: \$LINENO "
```


## Перечитать partition-table

Никак, пробовал:

``` shell
partprobe /dev/sda (warning : kernel failed to reread ....)
hdparm -z /dev/sda (BLKRRPART failed : device or resource busy)
blockdev -rereadpt /dev/sda (BLKRRPART failed : device or resource busy)
sfdisk -R /dev/sda (BLKRRPART failed : device or resource busy)
```

## Найти последние изменённые файлы на Linux-сервере

``` shell
find  /app -xdev -type f -mtime -3 | egrep -v "(localtime|proc|resolv|boot|hosts|.git|/tmp/)"
```

- `-mtime 3` - количество дней в течении которых нужны изменения.
- `/app` - папка в которой происходит поиск изменений

## Побайтовый бэкап системы

``` shell
mount /dev/sdc1 /mnt/backup/
dd if=/dev/sda of="/mnt/backup/system.$(date +"%Y-%m-%d").img" bs=4096
```

## Конвертирование образов виртуальных машин

``` shell
sudo qemu-img convert host.qcow2 host.raw
VBoxManage convertdd test.raw test.vdi
```

## Получить список IP-адресов на машине:

``` shell
ip addr | egrep -wo '([0-9]{1,3}\.*){4}/[0-9]{1,2}'
```

или

``` shell
ip -o -f "inet" addr | awk '{print $4}'
```

## Победить долгое подключение по SSH

Лучше разобраться с причиной, здесь набор костылей под разные проблемы.

``` shell
sed -E 's/.(UseDNS|GSSAPIAuthentication)./\1 no/g' -i /etc/ssh/sshd_config
yum -y install nscd
service nscd restart
echo options single-request >> /etc/resolv.conf
service sshd reload
```

## Сжать qcow2 диск

По-хорошему после подчистки места и перед сжатием образа, нужно сделать зачистку файловой системы - создать большой файл, забитый нулями, а затем удалить.

``` shell
sudo qemu-img convert -c -f qcow2 -O qcow2 carbon_ci.img carbon_ci_zip.img
```

## Проброс порта на SSH

- 10.11.12.13 - адрес машины за NAT
- 22 порт - сейчас используется SSH-сервером
- 8686 порт будет доступен снаружи

``` shell
iptables -t nat -I PREROUTING -p tcp --dport 8686 -j DNAT --to-dest 10.11.12.13:22
iptables -I FORWARD -s 10.11.12.13 -j ACCEPT
iptables -I FORWARD -d 10.11.12.13 -j ACCEPT
```

## Конвертировать содержимое файла в char

``` shell
hexdump -v -e '12/1 "0x%02X, " "\n"' file.txt | sed 's/0x  /0x00/g'
```

## Установить nslookup

Он устарел, лучше используйте dig:

``` shell
yum install bind-utils
```

## Определить внешние утилиты, используемые в скрипте

``` shell
strace -f -s 100 -e trace=execve ./test.sh 2>&1 | grep -o "execve.*" | sort
```

## Починить проброс X'ов по SSH после отключения ipv6 и перезагрузки

Укажите в sshd_config:

```
AddressFamily inet
```

## Показать настройки IPv4 только для ethernet-интерфейсов без grep:

Ннапример если много туннелей:

``` shell
ip -o -4 addr show label eth*
```

## Как указать конкретное зеркало yum

в конфиге `/etc/yum/pluginconf.d/fastestmirror.conf` указать `include_only`:

``` shell
[main]
enabled=1
verbose=0
always_print_best_host = true
socket_timeout=3
hostfilepath=timedhosts.txt
maxhostfileage=10
maxthreads=15
include_only=mirror.yandex.ru
```

## Форсировать обновление дистрибутива CentOS

Yum может сообщать о том, что текущая установленная версия - ещё не выпущена. Можно обойти это так:

``` shell
echo 6.6 > /etc/yum/vars/releasever
rpm -Uvh http://mirror.yandex.ru/centos/6.6/os/x86_64/Packages/centos-release-6-6.el6.centos.12.2.x86_64.rpm
yum -y update
```

## Добавление VLAN

``` shell
#!/bin/bash

set -euE

dev="$1"
tag="$2"

ip link add link "$dev" name "$dev.$tag" type vlan id "$tag"
ip link set "$dev.$tag" up
```

## Развернуть систему сборки ядра CentOS 6

``` shell
#!/bin/bash

SRCRPM="http://vault.centos.org/6.6/os/Source/SPackages/kernel-2.6.32-504.el6.src.rpm"
curl https://raw.githubusercontent.com/hordecore/cookbooks/devel/centos7_prototype.sh | bash
yum -y groupinstall "Development tools"
yum -y install xmlto asciidoc elfutils-libelf-devel elfutils-devel binutils-devel newt-devel  python-devel audit-libs-devel "perl(ExtUtils::Embed)" hmaccalc ncurses-devel
rpm -i "$SRCRPM"
rm -f /dev/random
ln -s /dev/urandom /dev/random
cd /root/rpmbuild/SPECS
rpmbuild -bp kernel.spec
```

## Подпись запроса на сертификат с помощью OpenSSL

``` shell
openssl ca \
	-config /cfg/cert/cert.cfg \
	-cert /cfg/cert/ca.crt \
	-keyfile /cfg/cert/ca.key \
	-in /root/request_from_human.csr \
	-out /root/cert_for_human.crt
```

- Запрос - `/root/request_from_human.csr`
- Подпись на выходе - `/root/cert_for_human.crt`

## Конвертация IP в uint32 и обратно на bash

``` shell
ip2string() {
		a="$(($1>>24))"
		b="$(($1-(a<<24)>>16))"
		c="$((($1-(a<<24)-(b<<16))>>8))"
		d="$((($1-(a<<24)-(b<<16))-(c<<8)))"
		echo "$a.$b.$c.$d"
}

string2ip() {
		IFS=. read a b c d <<< "$1"
		echo "$(( (a<<24) + (b<<16) + (c<<8) + d))"
}
```

## Регулярное выражение egrep для приватных IPv4 сетей

```
"^1(27\.|92\.168\.|0\.|72\.(1[6-9]|2[0-9]3[01]))[0-9.]*$"
```

Создание chroot-jail в CentOS:

``` shell
name="grafana"
mkdir -p "/containers/$name/etc/yum.repos.d/"
sed s/'$releasever'/6/g /etc/yum.repos.d/CentOS-Base.repo > "/containers/$name/etc/yum.repos.d/CentOS-Base.repo"
yum groupinstall core --installroot="/containers/$name/" --nogpgcheck -y
export PATH="$PATH:/bin/:/sbin/"
chroot "/containers/$name/" rpm -vv --rebuilddb
```

## Установка Bat в CentOS (и любого другого Go-кода)

``` shell
yum -y install golang
export GOPATH=~/git/go/
mkdir -p $GOPATH/src/
cd $GOPATH/src/
git clone https://github.com/astaxie/bat.git
go get
go build
cp bat/bat /usr/local/bin/bat
```

## Установить шаблоны LXC в CentOS

``` shell
yum -y install lxc-templates
```

## Починить зависающий ntpdate в CentOS

``` shell
sed -e 's/^server //; s/ iburst$//' -i /etc/ntp/step-tickers
```

## Трасировка кода в ядре Linux с помощью ftrace

В CentOS 6.7 работает. Прочитал о нём [на хабре в бложеке селектела](https://habrahabr.ru/company/selectel/blog/280322/). Плюсы: можно указать список трасируемых функций, можно строить текстовые графы. Подводные камни: в `avaible_filter_set` содержатся не все функции отлаживаемого модуля, но часть их - на месте. От чего это зависит - не понимаю.

## Создать задержку HTTP-запросов с помощью tc на шлюзе с Linux

Всё очень упрощённо, без подчистки за собой.

Мне нужно было добавить секундную задержку только для GET-запросов, чтобы установка соединения и последующий обмен ACK'ами не замедлялись.

```
#!/bin/bash

set -eu

IF="${1:-eth3}"
IFSPEED=1000Mbps
DELAY="${2:-1000ms}"
CLASS=11
ROOT=1

tc qdisc  add dev $IF handle $ROOT: root htb
tc class  add dev $IF parent $ROOT: classid $ROOT:$CLASS htb rate $IFSPEED
tc qdisc  add dev $IF parent $ROOT:$CLASS handle $CLASS: netem delay $DELAY
tc filter add dev $IF parent $ROOT:0 prio 1 protocol ip handle $CLASS fw flowid $ROOT:$CLASS
iptables -t mangle -A POSTROUTING -o $IF -p tcp --dport 80 -m string --string 'GET' --algo 'bm' -j MARK --set-mark $CLASS
```

## Избежать сброса локали при подключении по SSH в MacOS

Я очень сильно промучался с тем, что при ssh на Linux-сервера с моей MacOS переменные `LANG` и `LC_ALL`, `LC_CTYPE` сбрасывались в `C`, вместо `ru_RU.UTF-8`, в результате в vim с кириллическими символами творилась лютая кракозябра. В `~/.ssh/ssh_config` SendEnv почему-то игнорировался (в `ssh -vvv` было написано что файл читается, хз в чём прикол), но в `/etc/ssh/ssh_config` проканало.

Собственно нужно туда добавить строчки:

```
Host *
    SendEnv LANG LC_*
```

## Убедиться в отзыве SSL-сертификата

Вводные: получаем ошибку SEC_ERROR_REVOKED_CERTIFICATE

1. https://www.ssllabs.com/ssltest/
2. Ищем "Revocation status"
3. Если не отозван - дело в чём-то другом
4. Если отозван, ищем информацию об отзыве.
	1. Найдите серийный номер вашего сертификат. Мне это удалось только через Safari, до того как он обновил списки отозванных сертификатов, Firefox не показывает никакой отладочной информации, если сталкивается с отозванным сертификатом. Есть два способа:
    2. CRL:
		1. `wget "http://crl.comodoca.com/COMODORSADomainValidationSecureServerCA.crl" -O COMODORSADomainValidationSecureServerCA.crl`
		2. `openssl crl -inform DER -text -noout -in COMODORSADomainValidationSecureServerCA.crl | grep -A 1 YOUR_CERT_SERIAL_NUMBER_WITHOUT_SPACES`
    3. OCSP: http://ocsp.comodoca.com

## Отключить турбобуст

``` shell
echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
```

## Посчитать общий размер списка файлов перечисленных в файле:

``` shell
eval echo '$((('"$(while read line; do du -s $line; done < backups.conf | while read x d; do echo -n $x+; done)"'0 ) / 1024 / 1024))'
```

## Посмотреть температуру процессоров

``` shell
modprobe coretemp
grep '' /sys/class/hwmon/hwmon*/device/temp*_input
```

## Отслеживать изменения файлов в директории

``` shell
inotifywait -mr /tmp
```

## Убить программы, съевшие всё место удалёнными незакрытыми файлами

``` shell
#!/bin/bash

ls -l /proc/*/fd/* 2>/dev/null | grep -i deleted | while read -r fd; do
    : > $fd
    echo $fd
done | grep -o /proc.*fd/ | tr -d '/a-zA-Z' | sort -u | while read pid; do
    ps aux | grep "$pid"
    kill -KILL "$pid"
done
```

## Конвертировать unixtime во время в формате ЧЧ:ММ:СС

Linux:

``` shell
date --date @$1 +%H:%M:%S
```

MacOS:

``` shell
date -r $1 +%H:%M:%S
```

## Посмотреть сколько файлов открыл пользователь

``` shell
lsof -u nginx | awk '{print $9}' | sort | uniq | wc -l
```

## Синхронизация содержимого двух директорий с помощью rsync

(обязательно с / в конце оба аргумента)

``` shell
rsync -a --delete 1/ 2/
```

## Запускать все SSH-подключения в вербозном режиме

Удобно, когда часто подключаешься и нужно понимать, файрволом тебя режет, сервер недоступен или удалённый сервер тормозит. В файл `~/.ssh/config` нужно добавить:

```
Host *
    LogLevel DEBUG
```

## Автоматически установить всё что просит rpmbuild

``` shell
rpmbuild -bp coreutils.spec 2>&1  | grep -v ошибка | while read pkg _; do yum -y install $pkg; done
```

## Найти все перезагрузки Linux-сервера

``` shell
find /var/log/sa/ -type f | sort -n | while read f; do sar -f "$f" 2>/dev/null | grep -i restart && echo $f; done
```

## Транспонирование вывода в PostgreSQL

``` sql
SELECT * FROM table\gx
```

## Разобраться кто активно использует память, а кто свопится (и ему норм)

``` shell
smem  -ktrs rss
```

## Поиск утечек памяти в python

``` python
import tracemalloc
import os, resource
import guppy

h = guppy.hpy()
tracemalloc.start()


def memstat(label="", count=10):
    snapshot = tracemalloc.take_snapshot()
    top_stats = snapshot.statistics('lineno')
    usage=resource.getrusage(resource.RUSAGE_SELF)
    heap = h.heap()
    print(f'RESOURCE_USAGE[{os.getpid()}]: {label}: mem={usage[2]/1024.0} mb')
    print(str(heap[0]).split('\n')[0])
    print(f"[ Top {label} {count} ]")
    for stat in top_stats[:count]:
        print(stat)
```
