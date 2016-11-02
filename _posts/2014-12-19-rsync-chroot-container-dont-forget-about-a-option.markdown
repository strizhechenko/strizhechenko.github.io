---
layout: post
title: Rsync chroot container? Don't forget about '-a' option!
date: '2014-12-19 09:24:06'
---

If you don't want to copy broken chroot-jail, use -a option of rsync, else you get only dir/files, without symlinks and can't chroot into container.