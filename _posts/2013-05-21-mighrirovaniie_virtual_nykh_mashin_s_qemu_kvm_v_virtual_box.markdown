---
layout: post
title: "Мигрирование виртуальных машин с Qemu/KVM в VirtualBox"
date: '2013-05-21 05:40:00'
---

1\. получаем список образов диска

virsh dumpxml host | egrep "(img|qcow|qcow2)"

2\. конвертируем qcow2 в raw.

sudo qemu-img convert host.qcow2 host.raw

3\. на машине с virtualbox.

VBoxManage convertdd test.raw test.vdi