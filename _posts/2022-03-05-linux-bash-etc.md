---
title: Однострочники Linux, bash, python, SQL
---

## Хоткеи bash

- **ctrl+w** - с конца удаляет одно слово
- **ctrl-u** - удаляет всё в строке сразу, но это чреватая практика, если набрал много текста и он может пригодиться, лучше хак юзать
- **ctrl-a**, ставим `#` в начале, жмём enter - вуаля, этот текст сохранён в истории
- если надо - можно его найти через **ctrl-r**, это поиск по подстроке
- **ctrl-e** - убежать в конец строки

## Сжатие

Максимально быстрая распаковка больших gzip архивов

```
sudo nice -n -19 gunzip -v -c bigarchive.gz > superbigfile.ext
```

## Bash (программирование и оболочки)

[Шаблон bash-скрипта](https://github.com/carbonsoft/crab_utils/blob/templates/tmplt/tmplt_bash)


### Выводить значение переменной в bash перед каждым действием:

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

### Показывать в режиме bash -x номер выполняемой строки:

``` shell
PS4="$PS4 line: \$LINENO "
```

### Предотвратить поглощение stdin при использовании ssh в цикле

``` shell
while read -r something; do
	./your_script_using_ssh_or_ssh_itself.sh "$something" < /dev/null
done
```

#### Конвертировать unixtime во время в формате ЧЧ:ММ:СС

Linux:

``` shell
date --date @$1 +%H:%M:%S
```

MacOS:

``` shell
date -r $1 +%H:%M:%S
```

### IPv4

#### Конвертация IPv4 в uint32 и обратно на bash

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

#### Регулярное выражение egrep для приватных IPv4 сетей

```
"^1(27\.|92\.168\.|0\.|72\.(1[6-9]|2[0-9]3[01]))[0-9.]*$"
```

## Linux (системные штуки), SSH

### Железо

#### Отключить турбобуст

``` shell
echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
```

#### Посмотреть температуру процессоров

``` shell
modprobe coretemp
grep '' /sys/class/hwmon/hwmon*/device/temp*_input
```

### SSH

#### Победить долгое подключение по SSH

Лучше разобраться с причиной, здесь набор костылей под разные проблемы.

``` shell
sed -E 's/.(UseDNS|GSSAPIAuthentication)./\1 no/g' -i /etc/ssh/sshd_config
yum -y install nscd
service nscd restart
echo options single-request >> /etc/resolv.conf
service sshd reload
```

или совсем уж костыли - указывать в `~/.ssh/config` путь к `IdentityFile` (обычно `~/.ssh/id_rsa`), чтобы ssh при подключении не обходил потенциальные варианты, которых всё равно нет.

#### Починить проброс X'ов по SSH после отключения ipv6 и перезагрузки

Укажите в `sshd_config`:

```
AddressFamily inet
```

#### Избежать сброса локали при подключении по SSH в MacOS

Я очень сильно промучался с тем, что при ssh на Linux-сервера с моей MacOS переменные `LANG` и `LC_ALL`, `LC_CTYPE` сбрасывались в `C`, вместо `ru_RU.UTF-8`, в результате в vim с кириллическими символами творилась лютая кракозябра. В `~/.ssh/ssh_config` SendEnv почему-то игнорировался (в `ssh -vvv` было написано что файл читается, хз в чём прикол), но в `/etc/ssh/ssh_config` проканало.

Собственно нужно туда добавить строчки:

```
Host *
    SendEnv LANG LC_*
```

#### Запускать все SSH-подключения в вербозном режиме

Удобно, когда часто подключаешься и нужно понимать, файрволом тебя режет, сервер недоступен или удалённый сервер тормозит. В файл `~/.ssh/config` нужно добавить:

```
Host *
    LogLevel DEBUG
```

#### Автоматически создать SSH-ключи без пароля

Не делайте так.

``` shell
ssh-keygen -N "" -f ~/.ssh/id_rsa
```

### Найти все перезагрузки Linux-сервера

``` shell
find /var/log/sa/ -type f | sort -n | while read f; do
	sar -f "$f" 2>/dev/null | grep -i restart && echo $f
done
```

### Разобраться кто активно использует память, а кто свопится (и ему норм)

``` shell
smem  -traks rss
```

### Перечитать partition-table

Никак, пробовал:

``` shell
partprobe /dev/sda (warning : kernel failed to reread ....)
hdparm -z /dev/sda (BLKRRPART failed : device or resource busy)
blockdev -rereadpt /dev/sda (BLKRRPART failed : device or resource busy)
sfdisk -R /dev/sda (BLKRRPART failed : device or resource busy)
```

### Настроить статику в LXC с netplan

``` shell
cat > /etc/netplan/10-lxc.yaml << EOF
network:
  ethernets:
    eth0:
      dhcp4: no
      addresses: [192.168.1.4/26]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [192.168.1.1]
  version: 2
EOF
netplan apply
```

## Bash + Linux, однострочники

### Взаимодействие с файлами

#### Синхронизация содержимого двух директорий с помощью rsync

(обязательно с / в конце оба аргумента)

``` shell
rsync -a --delete 1/ 2/
```

#### Найти последние изменённые файлы на Linux-сервере

``` shell
find  /app -xdev -type f -mtime -3 | egrep -v "(localtime|proc|resolv|boot|hosts|.git|/tmp/)"
```

- `-mtime 3` - количество дней в течении которых нужны изменения.
- `/app` - папка в которой происходит поиск изменений

#### Посчитать общий размер списка файлов перечисленных в файле:

``` shell
eval echo '$((('"$(while read line; do du -s $line; done < backups.conf | while read x d; do echo -n $x+; done)"'0 ) / 1024 / 1024))'
```

#### Отслеживать изменения файлов в директории

``` shell
inotifywait -mr /tmp
```

#### Посмотреть сколько файлов открыл пользователь

``` shell
lsof -u nginx | awk '{print $9}' | sort | uniq | wc -l
```

#### Убить программы, съевшие всё место удалёнными незакрытыми файлами

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

### Побайтовый бэкап системы

``` shell
mount /dev/sdc1 /mnt/backup/
dd if=/dev/sda of="/mnt/backup/system.$(date +"%Y-%m-%d").img" bs=4096
```

### Проверить, были ли в логах сервиса сообщения с таким-то шаблоном за последний час

``` shell
hour_ago="$(date +"%Y-%m-%d %H:%M" --date -1hour)"
journalctl --since="$hour_ago" -u whatsapp-socketio --grep 'failure.*reason="405"
```

Если ничего не найдётся, код возврата будет равен 1, если найдётся — 0, так что команду можно использовать в вызовах вида ```if journalctl...--since... --grep...; then```.

### iproute2 examples

#### Получить список IP-адресов на машине:

``` shell
ip addr | egrep -wo '([0-9]{1,3}\.*){4}/[0-9]{1,2}'
```

или

``` shell
ip -o -f "inet" addr | awk '{print $4}'
```

#### Показать настройки IPv4 только для ethernet-интерфейсов без grep:

Например если много туннелей:

``` shell
ip -o -4 addr show label eth*
```

#### Добавление VLAN

``` shell
#!/bin/bash

set -euE

dev="$1"
tag="$2"

ip link add link "$dev" name "$dev.$tag" type vlan id "$tag"
ip link set "$dev.$tag" up
```

### iptables

#### Проброс порта на SSH

- 10.11.12.13 - адрес машины за NAT
- 22 порт - сейчас используется SSH-сервером
- 8686 порт будет доступен снаружи

``` shell
iptables -t nat -I PREROUTING -p tcp --dport 8686 -j DNAT --to-dest 10.11.12.13:22
iptables -I FORWARD -s 10.11.12.13 -j ACCEPT
iptables -I FORWARD -d 10.11.12.13 -j ACCEPT
```

#### Создать задержку HTTP-запросов с помощью tc на шлюзе с Linux

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

tc qdisc add dev $IF handle $ROOT: root htb
tc class add dev $IF parent $ROOT: classid $ROOT:$CLASS htb rate $IFSPEED
tc qdisc add dev $IF parent $ROOT:$CLASS handle $CLASS: netem delay $DELAY
tc filter add dev $IF parent $ROOT:0 prio 1 protocol ip handle $CLASS fw flowid $ROOT:$CLASS
iptables -t mangle -A POSTROUTING -o $IF -p tcp --dport 80 -m string --string 'GET' --algo 'bm' -j MARK --set-mark $CLASS
```

### Выборки по TCP-соединениям

#### Распределение состояний Conntrack

``` shell
conntrack -d $YOUR_DST_IP -p tcp -L | awk '{print $4}' | sort | uniq -c
```

#### TOP-10 хостов, установивших соединение

``` shell
conntrack -d $YOUR_DST_IP -p tcp -L | awk '{print $5}' | sort | uniq -c | sort -nr | head -n 10
```

#### Распределение клиентских хостов по числу TCP-сессий

1 колонка - число хостов, 2 колонка - число открытых сессий на хост. Смотреть глазами одинаковые данные больно, засуньте в Excel.

``` shell
conntrack -d $YOUR_DST_IP -p tcp -L | awk '{print $5}' | sort | uniq -c | sort -nr | awk '{print $1}' | sort -nr | uniq -c
```

### Конвертировать содержимое файла в char

``` shell
hexdump -v -e '12/1 "0x%02X, " "\n"' file.txt | sed 's/0x  /0x00/g'
```

### Yum, CentOS, Kernel

#### Починить зависающий ntpdate

``` shell
sed -e 's/^server //; s/ iburst$//' -i /etc/ntp/step-tickers
```

#### Установить nslookup

Он устарел, лучше используйте dig:

``` shell
yum install bind-utils
```

#### Указать конкретное зеркало Yum

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

#### Форсировать обновление дистрибутива CentOS

Yum может сообщать о том, что текущая установленная версия - ещё не выпущена. Можно обойти это так:

``` shell
echo 6.6 > /etc/yum/vars/releasever
rpm -Uvh http://mirror.yandex.ru/centos/6.6/os/x86_64/Packages/centos-release-6-6.el6.centos.12.2.x86_64.rpm
yum -y update
```

#### Развернуть систему сборки ядра CentOS 6

``` shell
#!/bin/bash

SRCRPM="http://vault.centos.org/6.6/os/Source/SPackages/kernel-2.6.32-504.el6.src.rpm"
curl https://raw.githubusercontent.com/hordecore/cookbooks/devel/centos7_prototype.sh | bash
yum -y groupinstall "Development tools"
yum -y install xmlto asciidoc elfutils-libelf-devel elfutils-devel binutils-devel newt-devel python-devel audit-libs-devel "perl(ExtUtils::Embed)" hmaccalc ncurses-devel
rpm -i "$SRCRPM"
rm -f /dev/random
ln -s /dev/urandom /dev/random
cd /root/rpmbuild/SPECS
rpmbuild -bp kernel.spec
```

#### Автоматически установить всё что просит rpmbuild

``` shell
rpmbuild -bp coreutils.spec 2>&1  | grep -v ошибка | while read pkg _; do yum -y install $pkg; done
```

#### Трасировка кода в ядре Linux с помощью ftrace

В CentOS 6.7 работает. Прочитал о нём [на хабре в бложеке селектела](https://habrahabr.ru/company/selectel/blog/280322/). Плюсы: можно указать список трасируемых функций, можно строить текстовые графы. Подводные камни: в `avaible_filter_set` содержатся не все функции отлаживаемого модуля, но часть их - на месте. От чего это зависит - не понимаю.

#### Создание chroot-jail в CentOS:

``` shell
name="grafana"
mkdir -p "/containers/$name/etc/yum.repos.d/"
sed s/'$releasever'/6/g /etc/yum.repos.d/CentOS-Base.repo > "/containers/$name/etc/yum.repos.d/CentOS-Base.repo"
yum groupinstall core --installroot="/containers/$name/" --nogpgcheck -y
export PATH="$PATH:/bin/:/sbin/"
chroot "/containers/$name/" rpm -vv --rebuilddb
```

#### Установка Bat (и любого другого Go-кода) в CentOS

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

#### Установить шаблоны LXC в CentOS

``` shell
yum -y install lxc-templates
```

#### В CentOS 8 не хватает ANSI_X3.4-1968 чтобы выставить кириллическую локаль

В результате выхлоп ls с кириллическими именами показывает ????

``` shell
dnf -y install glibc-locale-source
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
```

### Определить внешние утилиты, используемые в скрипте

``` shell
strace -f -s 100 -e trace=execve ./test.sh 2>&1 | grep -o "execve.*" | sort
```

## Libvirt, виртуализация, образы дисков VM

### Установка через virt-install

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

### Конвертирование QCOW2 в VirtualBox

``` shell
sudo qemu-img convert host.qcow2 host.raw
VBoxManage convertdd test.raw test.vdi
```

### Сжать qcow2 диск

По-хорошему после подчистки места и перед сжатием образа, нужно сделать зачистку файловой системы - создать большой файл, забитый нулями, а затем удалить.

``` shell
sudo qemu-img convert -c -f qcow2 -O qcow2 carbon_ci.img carbon_ci_zip.img
```

## OpenSSL, HTTPS, сертификаты

### Сделать самоподписные сертификаты

Максимально просто, без корневого сертификата, внятного subject итд.

``` shell
cert=/etc/nginx/ssl/ecc.pem
key=/etc/nginx/ssl/ecc.key
req=/etc/nginx/ssl/ecc.csr
if [ ! -f "$cert" -o ! -f "$key" ]; then
	openssl ecparam -out "$key" -name prime256v1 -genkey
	openssl req -new -key "$key" -out "$req" -subj "/C=RU/"
	openssl req -x509 -nodes -days 365 -key "$key" -in "$req" -out "$cert"
fi
```


### Посмотреть что там с SSL-сертификатом у хоста

Вместо -connect можно использовать -showcerts, но я не очень понимаю в чём разница.

``` shell
openssl s_client -connect example.com:443 < /dev/null | openssl x509 -noout -text
```

Первая команда показывает сертификаты в сыром виде.

Вторая "парсит" их и выводит подробности вплоть до `alt_names`.

### Убедиться в отзыве SSL-сертификата

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

## SQL, Postgres

### Транспонирование вывода в PostgreSQL

``` sql
SELECT * FROM table\gx
```

### Делаем Redis INCR из буханки с PostgreSQL

Можно использовать простой советский CREATE SEQUENCE, это вариант на случай, если не хочется тащить динамику в DDL.

``` sql
INSERT INTO sequences (key) VALUES ('key')
ON CONFLICT(key) DO UPDATE SET value = sequences.value + 1
RETURNING value;
```

### Копирование в таблицу из CSV с клиента

```
\copy section from 'local/path/input.csv' csv delimiter ',';
```

Есть заголовок header, который типа указывает читать список полей из первой строки CSV, но у меня он игнорировался.

### Статистика по числу записей в таблице с определённым значением без seq-scan

Это приблизительные значения самых популярных значений. Они не совпадают на 100% с реальностью и не обновляются при каждой вставке. Тем не менее, считаю это на порядки более правильный подход для сбора метрик из крупных таблиц в мониторингах и т.д.

Оно хорошо подходит для отслеживания распределений всяких статусных полей до тех пор, пока вы укладываетесь в 6-7 возможных значений поля. В случае, если возможных значений больше, может быть правильным решением просто собирать метрики реже (и таки упираться в seq scan).

``` sql
SELECT columnname, (reltuples * mcf) :: int AS cnt
FROM (SELECT c.reltuples,
             unnest(s.most_common_vals :: text :: text[])   AS columnname,
             unnest(s.most_common_freqs :: text :: float[]) AS mcf
      FROM pg_stats s
               INNER JOIN pg_class c ON s.tablename = c.relname
      WHERE s.tablename = 'tablename'
        AND s.attname = 'columnname') raw;
```

### Размер колонки таблицы

``` sql
SELECT pg_size_pretty(sum(pg_column_size('column_name'))) FROM table_name;
```

### Статистика по таблице, индексу и колонке

Число записей в таблице:

``` sql
SELECT reltuples FROM pg_class WHERE relname = 'tablename';
```

Размер (и другие параметры) индекса:

``` sql
\di+ indexname
```

и по колонке с ним связанной:

``` sql
SELECT * FROM pg_stats WHERE tablename = 'tablename' AND attname = 'columnname' \gx
```

из особо интересного в выхлопе:

```
avg_width              | 61
n_distinct             | 1343
```

### Получить команду которой был создан существующий индекс

``` sql
SELECT pg_get_indexdef('indexname'::regclass);
```

## Python

### Поиск утечек памяти в python

Лучше не перемешивать разные способы профилирования. Себя они какими-то костылями из замеров отсекают, а вот друг-друга - вряд ли. В итоге получится профилирование профилировщиков профилировщиками, нелинейно разрастающееся с каждым замером.

``` python
import tracemalloc
tracemalloc.start()

def memstat(label="", count=10):
    snapshot = tracemalloc.take_snapshot()
    top_stats = snapshot.statistics('lineno')
    print(f"[ Top {label} {count} ]")
    for stat in top_stats[:count]:
        print(stat)
```

или

``` python
import os, resource
def memstat(label=""):
    usage=resource.getrusage(resource.RUSAGE_SELF)
    print(f'RESOURCE_USAGE[{os.getpid()}]: {label}: mem={usage[2]/1024.0} mb')
```

или

``` python
import guppy
h = guppy.hpy()

def memstat(label=""):
    heap = h.heap()
    print(label, str(heap[0]).split('\n')[0])
```

### "Профилирование" кусков кода принтами в питоне

``` python
TIMERS = dict()
PREV = None


def tick(key):
    global PREV
    global TIMERS
    try:
        TIMERS[key] = datetime.datetime.now()
        if PREV:
            print('TIMERS: DONE:', PREV, 'took', TIMERS[key] - TIMERS[PREV])
            del TIMERS[PREV]
        print("TIMERS: START:", key)
        PREV = key
    except Exception:
        logging.exception("TRACING EXCEPTION HAPPENED")
```
