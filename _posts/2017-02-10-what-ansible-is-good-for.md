---
title: Заметки об использовании Ansible
---

## Где он хорош

1. Многократное развёртывание одноразовых виртуалок, когда нужно тестировать само развёртывание.
2. Поддержание мелких настроек, таких как конфиг sshd, `.vimrc`, `.bashrc`, gitlab_token, установка timezone на куче долгоживущих виртуалок в единообразном состоянии.
3. Обновление пакетов на куче виртуалок.
4. Поддержание специфичных настроек **ГРУПП** виртуалок.
5. "Инвентаризация" может и звучит глупо, но иногда inventory-файл облегчает поиск IP нужной виртуалки.

## Почему он хорош

1. Модульность на нескольких уровнях. Группы хостов, задачи, конкретные хосты.
2. Никакого кода, только конфиги.
3. Многое доступно из коробки.
4. Большая часть модулей поддерживает "ленивый режим", не меняет ничего, если не надо.
5. Понравилась абстракция для service (enabled/restarted), не надо думать про конкретную систему управления сервисами
6. Формат вывода отчётов о запуске:

``` python
PLAY RECAP *********************************************************************
xxx.yyy.14.200              : ok=14   changed=0    unreachable=0    failed=0   
xxx.yyy.140.180             : ok=14   changed=0    unreachable=0    failed=0   
xxx.yyy.140.111              : ok=14   changed=0    unreachable=0    failed=0   
xxx.yyy.140.131              : ok=14   changed=0    unreachable=0    failed=0   
xxx.yyy.140.144              : ok=14   changed=0    unreachable=0    failed=0   
xxx.yyy.140.145              : ok=14   changed=0    unreachable=0    failed=0   
xxx.yyy.140.155              : ok=14   changed=1    unreachable=0    failed=0   
xxx.yyy.140.156              : ok=14   changed=0    unreachable=0    failed=0   
xxx.yyy.140.184              : ok=14   changed=8    unreachable=0    failed=0   
xxx.yyy.140.199              : ok=14   changed=0    unreachable=0    failed=0   
xxx.yyy.140.210              : ok=14   changed=2    unreachable=0    failed=0   
xxx.yyy.140.222              : ok=14   changed=2    unreachable=0    failed=0   
xxx.yyy.140.223              : ok=14   changed=0    unreachable=0    failed=0   
xxx.yyy.140.224              : ok=0    changed=0    unreachable=1    failed=0   
xxx.yyy.140.228              : ok=14   changed=0    unreachable=0    failed=0   
xxx.yyy.140.229              : ok=14   changed=0    unreachable=0    failed=0   
xxx.yyy.140.230              : ok=14   changed=1    unreachable=0    failed=0   
xxx.yyy.140.240              : ok=14   changed=1    unreachable=0    failed=0   
xxx.yyy.140.247              : ok=14   changed=8    unreachable=0    failed=0   
xxx.yyy.140.248              : ok=14   changed=8    unreachable=0    failed=0   
xxx.yyy.140.43               : ok=0    changed=0    unreachable=1    failed=0   
xxx.yyy.140.50               : ok=0    changed=0    unreachable=1    failed=0   
xxx.yyy.140.63               : ok=14   changed=1    unreachable=0    failed=0   
xxx.yyy.140.78               : ok=0    changed=0    unreachable=1    failed=0   
xxx.yyy.140.82               : ok=14   changed=0    unreachable=0    failed=0   
xxx.yyy.140.84               : ok=0    changed=0    unreachable=1    failed=0   
xxx.yyy.140.85               : ok=14   changed=0    unreachable=0    failed=0   
xxx.yyy.140.99               : ok=14   changed=0    unreachable=0    failed=0   
xxx.yyy.144.230              : ok=14   changed=8    unreachable=0    failed=0   
xxx.yyy.90.10                : ok=0    changed=0    unreachable=1    failed=0   
xxx.yyy.xxx.yyy.              : ok=14   changed=8    unreachable=0    failed=0   
xxx.yyy.1.140              : ok=0    changed=0    unreachable=1    failed=0   
```

## Где он плох

``` yaml
copy: src=xx dest=yyy
```

Часто опечатываюсь и пишу dst по аналогии с src, а не dest.

## Пример базовой task для виртуальных машин на CentOS

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
