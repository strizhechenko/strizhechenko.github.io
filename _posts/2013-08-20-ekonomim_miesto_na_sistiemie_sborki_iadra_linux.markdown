---
layout: post
title: "Экономим место на системе сборки ядра Linux"
date: '2013-08-20 08:27:00'
---

Если вы собираете ядра Linux и вам не нужна куча дебаговой информации, то:

1.  make menuconfig
2.  Kernel hacking
3.  Выключаем Compile the kernel with debug infoСокращаем размер /lib/modules/ приблизительно на 1.2Гб.