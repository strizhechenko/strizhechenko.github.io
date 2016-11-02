---
layout: post
title: Its really sad then codewriting is faster than man reading
date: '2013-12-04 11:50:00'
tags:
- bash2
- date
- seconds_to_hh_mm_ss
---

#SUCK MY BYDLOCODE, LOL

#!/bin/bash

nulling() {
&nbsp; &nbsp; &nbsp; &nbsp; [ "$1" -lt 10 ] &amp;&amp; echo 0$1 || echo $1
}

second2hms() {
&nbsp; &nbsp; &nbsp; &nbsp; x=$1
&nbsp; &nbsp; &nbsp; &nbsp; h=$((x / 3600))
&nbsp; &nbsp; &nbsp; &nbsp; d=$((x-h*3600))
&nbsp; &nbsp; &nbsp; &nbsp; m=$((d / 60))
&nbsp; &nbsp; &nbsp; &nbsp; s=$((d-m*60))
&nbsp; &nbsp; &nbsp; &nbsp; echo $(nulling $h):$(nulling $m):$(nulling $s)
}

second2hms $1