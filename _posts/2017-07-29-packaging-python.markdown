---
title: Упаковываем питон с помощью FPM
---

## Установка FPM

Окей, я поехавший и юзаю CentOS 6. Там всё плохо с старым Ruby, нам нужен rvm, чтобы поставить новый.

``` shell
yum groupinstall -y development
yum install ruby-devel gcc make rpm-build rubygems
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm reload
rvm install 2.1.0
rvm use 2.1.0 --default
gem install --no-ri --no-rdoc fpm
```

## Пакуем зависимости

У меня зависимость от ipaddress, которого нет в epel.

``` shell
fpm -s python -t rpm ipaddress
```

## Пробуем собрать свой пакет

``` shell
fpm -s python -t rpm netutils-linux
```

## Чиним зависимости

Окей, PyYAML какого-то хрена зовётся PyYAML, а не python-pyyaml (а импортится и вовсе как yaml), поэтому имеем адовые проблемы вида:

```
# yum install python-netutils-linux-2.3.1-1.noarch.rpm
Loaded plugins: fastestmirror
Setting up Install Process
Examining python-netutils-linux-2.3.1-1.noarch.rpm: python-netutils-linux-2.3.1-1.noarch
Marking python-netutils-linux-2.3.1-1.noarch.rpm to be installed
Loading mirror speeds from cached hostfile
 * base: mirror.yandex.ru
 * epel: mirror.awanti.com
 * extras: mirror.yandex.ru
 * updates: mirror.yandex.ru
Resolving Dependencies
--> Running transaction check
---> Package python-netutils-linux.noarch 0:2.3.1-1 will be installed
--> Processing Dependency: python-pyyaml for package: python-netutils-linux-2.3.1-1.noarch
--> Processing Dependency: python-six for package: python-netutils-linux-2.3.1-1.noarch
--> Processing Dependency: python-colorama for package: python-netutils-linux-2.3.1-1.noarch
--> Processing Dependency: python-prettytable for package: python-netutils-linux-2.3.1-1.noarch
--> Processing Dependency: PyYAML for package: python-netutils-linux-2.3.1-1.noarch
--> Running transaction check
---> Package PyYAML.x86_64 0:3.10-3.1.el6 will be installed
---> Package python-netutils-linux.noarch 0:2.3.1-1 will be installed
--> Processing Dependency: python-pyyaml for package: python-netutils-linux-2.3.1-1.noarch
---> Package python-prettytable.noarch 0:0.7.2-11.el6 will be installed
---> Package python-six.noarch 0:1.9.0-2.el6 will be installed
---> Package python2-colorama.noarch 0:0.3.7-3.el6 will be installed
--> Finished Dependency Resolution
Error: Package: python-netutils-linux-2.3.1-1.noarch (/python-netutils-linux-2.3.1-1.noarch)
           Requires: python-pyyaml
 You could try using --skip-broken to work around the problem
 You could try running: rpm -Va --nofiles --nodigest
```

Спасёт нас удаление унаследованной питоньей зависимости и явное определение RPM-зависимости:

``` shell
fpm -s python -t rpm -d PyYAML --python-disable-dependency pyyaml netutils-linux
```

## Победа!

```
# yum install python-netutils-linux-2.3.1-1.noarch.rpm
Loaded plugins: fastestmirror
Setting up Install Process
Examining python-netutils-linux-2.3.1-1.noarch.rpm: python-netutils-linux-2.3.1-1.noarch
Marking python-netutils-linux-2.3.1-1.noarch.rpm to be installed
Loading mirror speeds from cached hostfile
 * base: mirror.yandex.ru
 * epel: mirror.awanti.com
 * extras: mirror.yandex.ru
 * updates: mirror.yandex.ru
Resolving Dependencies
--> Running transaction check
---> Package python-netutils-linux.noarch 0:2.3.1-1 will be installed
--> Processing Dependency: python-six for package: python-netutils-linux-2.3.1-1.noarch
--> Processing Dependency: python-colorama for package: python-netutils-linux-2.3.1-1.noarch
--> Processing Dependency: python-prettytable for package: python-netutils-linux-2.3.1-1.noarch
--> Processing Dependency: PyYAML for package: python-netutils-linux-2.3.1-1.noarch
--> Running transaction check
---> Package PyYAML.x86_64 0:3.10-3.1.el6 will be installed
---> Package python-prettytable.noarch 0:0.7.2-11.el6 will be installed
---> Package python-six.noarch 0:1.9.0-2.el6 will be installed
---> Package python2-colorama.noarch 0:0.3.7-3.el6 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

============================================================================================================================================================================================================
 Package                                            Arch                                Version                                    Repository                                                          Size
============================================================================================================================================================================================================
Installing:
 python-netutils-linux                              noarch                              2.3.1-1                                    /python-netutils-linux-2.3.1-1.noarch                              212 k
Installing for dependencies:
 PyYAML                                             x86_64                              3.10-3.1.el6                               base                                                               157 k
 python-prettytable                                 noarch                              0.7.2-11.el6                               base                                                                37 k
 python-six                                         noarch                              1.9.0-2.el6                                base                                                                28 k
 python2-colorama                                   noarch                              0.3.7-3.el6                                epel                                                                29 k

Transaction Summary
============================================================================================================================================================================================================
Install       5 Package(s)

Total size: 465 k
Total download size: 252 k
Installed size: 1.2 M
Is this ok [y/N]: y
Downloading Packages:
(1/4): PyYAML-3.10-3.1.el6.x86_64.rpm                                                                                                                                                | 157 kB     00:00
(2/4): python-prettytable-0.7.2-11.el6.noarch.rpm                                                                                                                                    |  37 kB     00:00
(3/4): python-six-1.9.0-2.el6.noarch.rpm                                                                                                                                             |  28 kB     00:00
(4/4): python2-colorama-0.3.7-3.el6.noarch.rpm                                                                                                                                       |  29 kB     00:00
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                       344 kB/s | 252 kB     00:00
Running rpm_check_debug
Running Transaction Test
Transaction Test Succeeded
Running Transaction
  Installing : python-prettytable-0.7.2-11.el6.noarch                                                                                                                                                   1/5
  Installing : python2-colorama-0.3.7-3.el6.noarch                                                                                                                                                      2/5
  Installing : python-six-1.9.0-2.el6.noarch                                                                                                                                                            3/5
  Installing : PyYAML-3.10-3.1.el6.x86_64                                                                                                                                                               4/5
  Installing : python-netutils-linux-2.3.1-1.noarch                                                                                                                                                     5/5
  Verifying  : PyYAML-3.10-3.1.el6.x86_64                                                                                                                                                               1/5
  Verifying  : python-six-1.9.0-2.el6.noarch                                                                                                                                                            2/5
  Verifying  : python2-colorama-0.3.7-3.el6.noarch                                                                                                                                                      3/5
  Verifying  : python-netutils-linux-2.3.1-1.noarch                                                                                                                                                     4/5
  Verifying  : python-prettytable-0.7.2-11.el6.noarch                                                                                                                                                   5/5

Installed:
  python-netutils-linux.noarch 0:2.3.1-1

Dependency Installed:
  PyYAML.x86_64 0:3.10-3.1.el6                python-prettytable.noarch 0:0.7.2-11.el6                python-six.noarch 0:1.9.0-2.el6                python2-colorama.noarch 0:0.3.7-3.el6

Complete!
```


## Проблемы

Под MacOS fpm при конвертации python-репы в RPM-пакет делает RPM-пакет предназначенный только для MacOS, который не устанавливается на CentOS. Решается сборкой RPM-пакета на Travis-CI, но там свои заморочки. Наверное стоит сделать какой-нибудь хак, который проверяет, что если в коммите есть "Increment version", то выкладывать только в таком случае.

