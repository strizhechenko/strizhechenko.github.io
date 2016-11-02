---
layout: post
title: 'chroot: failed to run command `/bin/bash'': No such file or directory'
date: '2014-12-19 09:12:15'
---

May the STRACE be with you!

	[root@centosuser asr_cabinet]# LANG= strace -s100 -f -e trace=open chroot . ./lib64/ld-2.12.so  /bin/bash
    open("/etc/ld.so.cache", O_RDONLY)      = 3
    open("/lib64/libc.so.6", O_RDONLY)      = 3
    open("/bin/bash", O_RDONLY)             = 3
    open("/etc/ld.so.cache", O_RDONLY)      = 3
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