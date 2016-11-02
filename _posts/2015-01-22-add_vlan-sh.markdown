---
layout: post
title: add_vlan.sh
date: '2015-01-22 10:28:30'
---

    #!/bin/bash

    dev=$1
    tag=$2

    ip link add link $dev name $dev.$tag type vlan id $tag
    ip link set $dev.$tag up
