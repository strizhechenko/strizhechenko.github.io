---
layout: post
title: check execve in your bash scripts snippet
date: '2014-02-07 09:51:00'
---

strace -f -s 100 -e trace=execve ./test.sh 2&gt;&amp;1 | grep -o execve.* | sort