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

Долгое подключение по SSH:

``` shell
sed -E 's/.(UseDNS|GSSAPIAuthentication)./\1 no/g' -i /etc/ssh/sshd_config
service sshd reload
```

Сжатие qcow2 дисков.

По-хорошему после подчистки места и перед сжатием образа, нужно сделать зачистку файловой системы - создать большой файл, забитый нулями, а затем удалить.

``` shell
sudo qemu-img convert -c -f qcow2 -O qcow2 carbon_ci.img carbon_ci_zip.img
```

Проброс порта на SSH:

- 10.11.12.13 - адрес машины за NAT
- 22 порт - сейчас используется SSH-сервером
- 8686 порт будет доступен снаружи

``` shell
iptables -t nat -I PREROUTING -p tcp --dport 8686 -j DNAT --to-dest 10.11.12.13:22
iptables -I FORWARD -s 10.11.12.13 -j ACCEPT
iptables -I FORWARD -d 10.11.12.13 -j ACCEPT
```

Конвертировать содержимое файла в char:

``` shell
hexdump -v -e '12/1 "0x%02X, " "\n"' file.txt | sed 's/0x  /0x00/g'
```

Установить nslookup (он устарел, лучше используйте dig):

``` shell
yum install bind-utils
```

Какие внешние утилиты используются в скрипте:

``` shell
strace -f -s 100 -e trace=execve ./test.sh 2>&1 | grep -o "execve.*" | sort
```

После отключения ipv6 и перезагрузки перестал работать проброс X'ов по SSH.

Укажите в sshd_config:

```
AddressFamily inet
```

Показать настройки IPv4 только для ethernet-интерфейсов (например если много туннелей) без grep:

``` shell
ip -o -4 addr show label eth*
```

Показывать в режиме bash -x номер выполняемой строки:

``` shell
PS4="$PS4 line: \$LINENO "
```

Как указать конкретное зеркало yum

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

Добавление VLAN:

``` shell
#!/bin/bash

set -euE

dev="$1"
tag="$2"

ip link add link "$dev" name "$dev.$tag" type vlan id "$tag"
ip link set "$dev.$tag" up
```

Развернуть систему сборки ядра CentOS 6

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

Подпись запроса на сертификат с помощью OpenSSL

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

Конвертация IP в uint32 и обратно:

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

Форсировать обновление дистрибутива CentOS

Yum может сообщать о том, что текущая установленная версия - ещё не выпущена. Можно обойти это так:

``` shell
echo 6.6 > /etc/yum/vars/releasever
rpm -Uvh http://mirror.yandex.ru/centos/6.6/os/x86_64/Packages/centos-release-6-6.el6.centos.12.2.x86_64.rpm
yum -y update
```

Регулярное выражение egrep для приватных сетей:

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

Установка Bat в CentOS (и любого другого Go-кода):

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

Посчитать общий размер списка файлов перечисленных в файле:

``` shell
eval echo '$((('"$(while read line; do du -s $line; done < backups.conf | while read x d; do echo -n $x+; done)"'0 ) / 1024 / 1024))'
```
