---
layout: post
title: "Наверное можно считать общий размер списка файлов как-то проще."
date: '2014-04-11 06:14:00'
---

eval echo '$((('"$(while read line; do du -s $line; done &lt; backups.conf | while read x d; do echo -n $x+; done)"'0 ) / 1024 / 1024))'