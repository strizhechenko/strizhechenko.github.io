---
title: Где меня радует ansible
---

1. Многократное развёртывание одноразовых виртуалок, когда нужно тестировать само развёртывание.
2. Поддержание мелких настроек, таких как конфиг sshd, vimrc, bashrc, gitlab_token, установка timezone на куче долгоживущих виртуалок в единообразном состоянии.
3. Обновление пакетов на куче виртуалок.
4. Включение/выключение сервисов на куче виртуалок.
5. Установка необходимого окружения для удобства локального дебага и разработки: python2.7, ipython, virtualenv, pip, bash-completion.
6. Поддержание специфичных настроек **ГРУПП** виртуалок.
7. Да, "инвентаризация" звучит глупо, но иногда найти IP нужной виртуалки очень легко в inventory файле.

## Мой текущий основной task для всех CentOS виртуалок:

Костыли, мерзость, худшие практики.

``` yml
- hosts: [centos]
  tasks:
  - yum: name=libselinux-python state=present
  - copy: src=../templates/resolv.conf.j2 dest=/etc/resolv.conf
  - copy: src=../templates/sshd_config.j2 dest=/etc/ssh/sshd_config
  - copy: src=../templates/vimrc dest=/root/.vimrc
  - template: src=../templates/bashrc dest=/root/.bashrc
  - file: src=/usr/share/zoneinfo/Asia/Yekaterinburg dest=/etc/localtime state=link force=yes
  - yum: name=vim state=present
  - yum: name=epel-release state=present
  - copy: src=../templates/epel.repo dest=/etc/yum.repos.d/epel.repo
  - copy: src=../templates/venv dest=/usr/local/bin/venv
  - yum: name=bash-completion state=present
  - yum: name=ntp state=present
  - yum: name=ntpdate state=present
```
