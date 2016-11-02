---
layout: post
title: "Как по быстрому сделать виртуалку с centos 6 средой для ковыряния ядра"
date: '2015-01-22 09:17:01'
---

	#!/bin/bash
    
    curl https://raw.githubusercontent.com/hordecore/cookbooks/devel/centos7_prototype.sh | bash
    yum -y groupinstall "Development tools"
    yum -y install xmlto asciidoc elfutils-libelf-devel elfutils-devel binutils-devel newt-devel  python-devel audit-libs-devel "perl(ExtUtils::Embed)" hmaccalc ncurses-devel
    rpm -i "http://vault.centos.org/6.6/os/Source/SPackages/kernel-2.6.32-504.el6.src.rpm"
    rm -f /dev/random
    ln -s /dev/urandom /dev/random
    cd /root/rpmbuild/SPECS
    rpmbuild -bp kernel.spec
	