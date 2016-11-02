---
layout: post
title: Deploy ghost on CentOS
date: '2015-07-31 10:13:54'
---

	yum -y install git epel-release
    sed -e 's/https/http/g' -i /etc/yum.repos.d/epel.repo 
	sed -e 's/https/http/g' -i /etc/yum.repos.d/epel-testing.repo 
    yum -y install npm
    git clone https://github.com/TryGhost/Ghost /opt/ghost/
    cd /opt/ghost
    npm install -g grunt-cli
    npm install --production
    grunt init
    grunt prod

    git clone https://github.com/strizhechenko/ghost-sysvinit.git /tmp/ghost-init
    cp -p /tmp/ghost-init/ghost /etc/rc.d/init.d/ghost
    chkconfig --level 345 ghost on
    service ghost restart
    
Забить хуй. Читать https://github.com/tryghost/Ghost