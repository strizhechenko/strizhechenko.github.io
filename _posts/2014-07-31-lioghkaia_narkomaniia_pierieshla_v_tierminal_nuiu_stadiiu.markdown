---
layout: post
title: "Лёгкая наркомания перешла в терминальную стадию"
date: '2014-07-31 14:09:00'
tags:
- bash2
- eval
- heavy_drugs
---

oleg@oleg:/ upload() { while read line; do echo qwe $line; done; } 
oleg@oleg:/ upload='' 
oleg@oleg:/ eval echo qwe ${upload//1/| upload} 
qwe 
oleg@oleg:/ upload=1 
oleg@oleg:/ eval echo qwe ${upload//1/| upload} 
qwe qwe