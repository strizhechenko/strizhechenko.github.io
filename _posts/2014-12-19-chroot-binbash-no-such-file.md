---
layout: post
title: 'chroot: failed to run command `/bin/bash'': No such file or directory'
date: '2014-12-19 09:12:15'
---

`strace` will help you!

```
# LANG= strace -s100 -f -e trace=open chroot . ./lib64/ld-2.12.so  /bin/bash
...
open("/lib64/libtinfo.so.5", O_RDONLY)  = -1 ENOENT (No such file or directory)
open("/lib64/tls/x86_64/libtinfo.so.5", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/lib64/tls/libtinfo.so.5", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/lib64/x86_64/libtinfo.so.5", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/lib64/libtinfo.so.5", O_RDONLY)  = -1 ENOENT (No such file or directory)
open("/usr/lib64/tls/x86_64/libtinfo.so.5", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/lib64/tls/libtinfo.so.5", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/lib64/x86_64/libtinfo.so.5", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/lib64/libtinfo.so.5", O_RDONLY) = -1 ENOENT (No such file or directory)
/bin/bash: error while loading shared libraries: libtinfo.so.5: cannot open shared object file: No such file or directory
```

You need to install libtinfo into chroot in this example.
