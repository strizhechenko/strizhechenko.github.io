---
layout: post
title: "Вот и я столкнулся с открытыми дескрипторами удалённых файлов съевшими всё
  место на диске"
date: '2013-12-05 08:44:00'
tags:
- linux
- '100_'
- df
- disc_usage
- du
- fd
- free_space
- proc
---

	#!/bin/bash

    ls -l /proc/*/fd/* 2>/dev/null | grep -i deleted | while read fd; do
    	: > $fd
    	echo $fd
    done | grep -o /proc.*fd/ | tr -d '/a-zA-Z' | sort -u | while read pid; do
    	kill -KILL $pid
    done