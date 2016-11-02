---
layout: post
title: Convert ip 2 uint32 and backward
date: '2015-02-13 07:06:49'
---

    ip2string() {
            a=$(($1>>24))
            b=$(($1-(a<<24)>>16))
            c=$((($1-(a<<24)-(b<<16))>>8))
            d=$((($1-(a<<24)-(b<<16))-(c<<8)))
            echo $a.$b.$c.$d
    }

    string2ip() {
            IFS=. read a b c d <<< "$1"
            echo $(( (a<<24) + (b<<16) + (c<<8) + d))       
    }