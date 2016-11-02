---
layout: post
title: "Шейперы без пэрентов"
date: '2015-03-11 10:03:33'
---

    cat stat_imq1.txt  | grep ^1:2 | while read shaper x; do grep "tc class replace.*$shaper" /var/log/firewall_usersd.log; done | grep -o "parent 1:.*classid" | sort -u
