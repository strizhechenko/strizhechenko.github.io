---
layout: post
title: "Дефолтный полинг сетёвок в linux говно"
date: '2015-01-26 11:06:51'
---

     70: 1714227466 0 0 0 0 0 0 0 0 0 0 0 IR-PCI-MSI-edge eth0-q0
     71: 1756792586 0 0 0 0 0 0 0 0 0 0 0 IR-PCI-MSI-edge eth0-q1
     72: 1945276717 0 0 0 0 0 0 0 0 0 0 0 IR-PCI-MSI-edge eth0-q2
     73: 2064481797 0 0 0 0 0 0 0 0 0 0 0 IR-PCI-MSI-edge eth0-q3
     
В итоге 10gbit сетёвка целиком сидит на 1 бедном ядре процессора, drop'ая около 20% пакетов.

Само по себе это не было бы так хреново, если бы не:

    cat /proc/irq/7[0-3]/smp_affinity_list 
    0-11
    0-11
    0-11
    0-11

Захачить без правки ядра не знаю как, поэтому наковырял баш-скриптец, сырой как яйцо младенца, но решающий в конкретном случае эту проблему.

    #!/bin/bash

    grep eth0 /proc/interrupts | while read irq t t t t t t t t t t t t t queue t; do
        irq=${irq//:}
        proc_entry=/proc/irq/$irq/smp_affinity_list
        evaled="${queue##*q}-11"
        echo $evaled > $proc_entry
    done