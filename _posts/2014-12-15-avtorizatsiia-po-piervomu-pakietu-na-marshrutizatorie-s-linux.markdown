---
layout: post
title: "Авторизация по первому пакету на роутере с Linux"
date: '2014-12-15 18:35:34'
---

Как-то сколько не наблюдаю за тем что люди пытаются сотворить чтобы получить сабж, удивляюсь, почему в голову не приходило что-то в духе:

1. Создаём git-репозиторий, инициализируем его
- Пишем arp таблицы всех интерфейсов на которых есть абоненты в одноимённые файлы в этом git репозитории
- git diff показывает нам добавившиеся ip адреса
- простейшим egrep получаем список новых адресов
- получаем список ip адресов из списка авторизованных абонентов
- убираем авторизованных из списка новых ip адресов
- по оставшимся делаем radius-запрос на авторизацию

Пока подводных камней в голову не пришло, самое крутое что даже программировать толком не надо для реализации.

### Набросок

update - получение ip из arp таблицы

    #!/bin/bash
    arp -n -i eth1 > arp.out

show_new - получаем новые адреса

	#!/bin/bash
    git diff | grep ^+ | egrep -o "([0-9]{1,3}\.){3}[0-9]{1,3}"
    
send_requests - отправляет radius-запросы

    #!/bin/bash

    while read ip; do
        echo "Request-Access to $ip" from 10.0.0.254
    done
    {
    git add .
    git commit -m "updated"
    } &>/dev/null
 
отправку radius-запроса авторизации я думаю уж нагуглить можно самостоятельно.