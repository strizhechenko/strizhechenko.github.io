---
layout: post
title: "Подробно о ccache: что за зверь, как настроить, что даст?"
date: '2013-08-30 10:31:00'
tags:
- centos
- debian
- kernel
- ccache
---

## Что за зверь

## Как установить

### CentOS 6

#### Установка
В репозиториях нет, поэтому> wget http://samba.org/ftp/ccache/ccache-3.1.9.tar.gztar xfz ccache-3.1.9.tar.gzcd ccache-3.1.9./configuremakemake install&nbsp;На досуге соберу в RPM возможно :)

## Как настроить
я билдю ядро из под рута, так что:vim ~/.bashrcmkdir ~/.ccache и дописываем туда:export CCACHE_DIR="/root/.ccache"export CC="ccache gcc"export CXX="ccache g++"export PATH="/usr/lib/ccache:$PATHВыполняемsource ~/.bashrcccache -M 4G

## Что даст
Люто бешено быструю повторную сборку ведра!Мне - норм.Когда ничего не изменилось[root@builder linux]# time make -j 3 bzImage  CHK     include/linux/version.h  CHK     include/linux/utsrelease.h  SYMLINK include/asm -> include/asm-x86  CALL    scripts/checksyscalls.sh  CHK     include/linux/compile.h  CHK     include/linux/version.hmake[2]: `scripts/unifdef' не требует обновления.Kernel: arch/x86/boot/bzImage is ready  (#4)real 0m11.637suser 0m15.895ssys 0m3.462sМеняем одну строчку в:/usr/src/linux/net/ipv4/ip_output.cБез ccache:[root@builder linux]# time make -j 3 bzImage  CHK     include/linux/version.h  CHK     include/linux/utsrelease.h  SYMLINK include/asm -> include/asm-x86  CALL    scripts/checksyscalls.sh  CHK     include/linux/compile.h  CC      net/ipv4/ip_output.o  LD      net/ipv4/built-in.o  LD      net/built-in.o  LD      vmlinux.o  MODPOST vmlinux.o  GEN     .version  CHK     include/linux/compile.h  UPD     include/linux/compile.h  CC      init/version.o  LD      init/built-in.o  LD      .tmp_vmlinux1  KSYM    .tmp_kallsyms1.S  AS      .tmp_kallsyms1.o  LD      .tmp_vmlinux2  KSYM    .tmp_kallsyms2.S  AS      .tmp_kallsyms2.o  LD      .tmp_vmlinux3  KSYM    .tmp_kallsyms3.S  AS      .tmp_kallsyms3.o  CHK     include/linux/version.hmake[2]: `scripts/unifdef' не требует обновления.  LD      vmlinux  SYSMAP  System.map  SYSMAP  .tmp_System.map  VOFFSET arch/x86/boot/voffset.h  CC      arch/x86/boot/version.o  OBJCOPY arch/x86/boot/compressed/vmlinux.bin  GZIP    arch/x86/boot/compressed/vmlinux.bin.gz  MKPIGGY arch/x86/boot/compressed/piggy.S  AS      arch/x86/boot/compressed/piggy.o  LD      arch/x86/boot/compressed/vmlinux  OBJCOPY arch/x86/boot/vmlinux.bin  ZOFFSET arch/x86/boot/zoffset.h  AS      arch/x86/boot/header.o  LD      arch/x86/boot/setup.elf  OBJCOPY arch/x86/boot/setup.bin  BUILD   arch/x86/boot/bzImageRoot device is (8, 1)Setup is 13500 bytes (padded to 13824 bytes).System is 3936 kBCRC 448606cbKernel: arch/x86/boot/bzImage is ready  (#5)real 0m20.127suser 0m23.633ssys 0m4.944sC ccache (ещё раз поменяли строчку).[root@builder linux]# time make -j 3 bzImage  CHK     include/linux/version.h  CHK     include/linux/utsrelease.h  SYMLINK include/asm -> include/asm-x86  CALL    scripts/checksyscalls.sh  CHK     include/linux/compile.h  CC      net/ipv4/ip_output.o  LD      net/ipv4/built-in.o  LD      net/built-in.o  LD      vmlinux.o  MODPOST vmlinux.o  GEN     .version  CHK     include/linux/compile.h  UPD     include/linux/compile.h  CC      init/version.o  LD      init/built-in.o  LD      .tmp_vmlinux1  KSYM    .tmp_kallsyms1.S  AS      .tmp_kallsyms1.o  LD      .tmp_vmlinux2  KSYM    .tmp_kallsyms2.S  AS      .tmp_kallsyms2.o  LD      .tmp_vmlinux3  KSYM    .tmp_kallsyms3.S  AS      .tmp_kallsyms3.o  CHK     include/linux/version.hmake[2]: `scripts/unifdef' не требует обновления.  LD      vmlinux  SYSMAP  System.map  SYSMAP  .tmp_System.map  VOFFSET arch/x86/boot/voffset.h  CC      arch/x86/boot/version.o  OBJCOPY arch/x86/boot/compressed/vmlinux.bin  GZIP    arch/x86/boot/compressed/vmlinux.bin.gz  MKPIGGY arch/x86/boot/compressed/piggy.S  AS      arch/x86/boot/compressed/piggy.o  LD      arch/x86/boot/compressed/vmlinux  ZOFFSET arch/x86/boot/zoffset.h  OBJCOPY arch/x86/boot/vmlinux.bin  AS      arch/x86/boot/header.o  LD      arch/x86/boot/setup.elf  OBJCOPY arch/x86/boot/setup.bin  BUILD   arch/x86/boot/bzImageRoot device is (8, 1)Setup is 13500 bytes (padded to 13824 bytes).System is 3936 kBCRC d2a2dfbbKernel: arch/x86/boot/bzImage is ready  (#6)real 0m19.377suser 0m23.141ssys 0m4.419sМагия блджад :CНачинаем тестить чуток иначе. Делаем make clean.Собираемmake -j 3 bzImagemake -j 3 modulesс ccache:time ./maker.shНа 13й минуте возник фэйл в сборке :C