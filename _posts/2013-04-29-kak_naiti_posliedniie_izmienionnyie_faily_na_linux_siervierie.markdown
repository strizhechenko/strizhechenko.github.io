---
layout: post
title: "Как найти последние изменённые файлы на Linux-сервере"
date: '2013-04-29 11:10:00'
tags:
- linux
- bash2
- poisk_izmienionnykh_failov
- kak_naiti_izmienieniia_po_vsiei_sistiemie
---

find  /app -xdev -type f -mtime -3 | egrep -v "(localtime|proc|resolv|boot|hosts|.git|/tmp/)"

-mtime 3 - это количество дней в течении которых нужны изменения.
/app - папка в которой происходит поиск изменений