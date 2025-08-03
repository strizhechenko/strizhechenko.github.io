---
title: Упаковываем питон с помощью FPM
---

## Установка FPM

Я использую CentOS 6, там есть сложности с старым Ruby, нужен rvm, чтобы обновить его.

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

Окей, PyYAML зовётся PyYAML, а не python-pyyaml (а импортируется как yaml), поэтому при установке имеем проблемы вида:

```
# yum install python-netutils-linux-2.3.1-1.noarch.rpm
...
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
...
Installed:
  python-netutils-linux.noarch 0:2.3.1-1
...
Complete!
```

## Проблемы MacOS

Под MacOS fpm при конвертации python-репозитория в RPM-пакет делает RPM-пакет предназначенный для MacOS, который не устанавливается на CentOS. Решается сборкой RPM-пакета на внешнем сервере с CentOS.
