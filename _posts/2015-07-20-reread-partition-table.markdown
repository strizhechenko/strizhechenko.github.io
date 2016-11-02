---
layout: post
title: Reread partition table (sad but true)
date: '2015-07-20 13:14:23'
---

All the following commands did not make kernel reread partition :

    partprobe /dev/sda (warning : kernel failed to reread ....)
    hdparm -z /dev/sda (BLKRRPART failed : device or resource busy)
    blockdev -rereadpt /dev/sda (BLKRRPART failed : device or resource busy)
    sfdisk -R /dev/sda (BLKRRPART failed : device or resource busy)

i still need a reboot to make it work

http://serverfault.com/questions/36038/reread-partition-table-without-rebooting