---
layout: post
title: 'При установке вашего RPM: cpio digest mismatch'
date: '2013-10-12 19:21:00'
tags:
- cpio_digest_mismatch
- prelink
- rhel
- rpm
---

Проблема как правило возникает при извлечении из архива prelinked бинарных файлов, например

```
/bin/cat
```

или

```
/bin/bash
```

но может случиться даже с tar-архивом.

Можно попробовать добавить в specfile строчку:

```
%global __prelink_undo_cmd %{nil}
```

по крайней мере мне помогло.
