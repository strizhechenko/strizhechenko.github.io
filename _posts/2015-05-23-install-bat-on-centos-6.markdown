---
layout: post
title: Install bat on centos 6
date: '2015-05-23 08:12:15'
tags:
- centos
- bat
- curl
---

	yum -y install golang
    
    export GOPATH=~/git/go/
    mkdir -p $GOPATH/src/
    cd $GOPATH/src/
    git clone https://github.com/astaxie/bat.git
    go get
    go build
    cp bat/bat /usr/local/bin/bat
    