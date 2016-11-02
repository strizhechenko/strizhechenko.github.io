---
layout: post
title: Chroot с CentOS 6
date: '2015-05-23 05:25:58'
---

Немного более лаконичный и кошерный вариант, чем тот который используется у меня на работе, #непроебин в общем.

	mkdir -p /containers/grafana/etc/yum.repos.d/
    sed s/'$releasever'/6/g /etc/yum.repos.d/CentOS-Base.repo > /containers/grafana/etc/yum.repos.d/CentOS-Base.repo
    yum groupinstall core --installroot=/containers/grafana/ --nogpgcheck -y
    export PATH=$PATH:/bin/:/sbin/
    chroot /containers/grafana/ rpm -vv --rebuilddb