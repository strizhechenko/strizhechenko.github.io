---
layout: post
title: "Однострочники в Linux"
date: '2012-12-31 02:27:00'
---

Максимально быстрая распаковка больших gzip архивов

```
sudo nice -n -19 gunzip -v -c bigarchive.gz > superbigfile.ext
```
