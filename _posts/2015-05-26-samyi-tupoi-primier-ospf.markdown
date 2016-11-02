---
layout: post
title: "Самый тупой пример OSPF"
date: '2015-05-26 06:53:19'
tags:
- linux
- ospfd
- zebra
- quagga
- routing
---

# Ospf Router A


## Настройки сети
    [root@ospf1 ~]# ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN 
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
        link/ether 52:54:00:c7:53:d8 brd ff:ff:ff:ff:ff:ff
        inet 10.90.140.231/16 brd 10.90.255.255 scope global eth0
    3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
        link/ether 52:54:00:b3:5a:ef brd ff:ff:ff:ff:ff:ff
        inet 192.168.10.1/16 brd 192.168.255.255 scope global eth1
    4: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN 
        link/ether da:30:2f:4b:ee:57 brd ff:ff:ff:ff:ff:ff
        inet 10.128.0.0/32 brd 10.128.0.0 scope global dummy0
    32: ppp0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1496 qdisc pfifo_fast state UNKNOWN qlen 3
        link/ppp 
        inet 10.128.0.0 peer 10.128.14.88/32 scope global ppp0

## zebra.conf

    !
    ! Zebra configuration saved from vty
    !   2015/05/25 19:35:54
    !
    hostname c10_90_140_231
    log file /var/log/quagga/zebra.log
    !
    interface dummy0
     ipv6 nd suppress-ra
    !
    interface eth0
     ipv6 nd suppress-ra
    !
    interface eth1
     ipv6 nd suppress-ra
    !
    interface lo
    !
    interface ppp0
     ipv6 nd suppress-ra
    !
    ip forwarding
    !
    !
    line vty
    !

## ospfd.conf

    !
    ! Zebra configuration saved from vty
    !   2015/05/25 19:35:55
    !
    log file /var/log/quagga/ospfd.log
    log stdout
    !
    debug ospf event
    !
    !
    interface dummy0
    !
    interface eth0
    !
    interface eth1
    !
    interface lo
    !
    interface ppp0
    !
    router ospf
     ospf router-id 10.90.140.231
     log-adjacency-changes
     redistribute kernel
     redistribute connected
     redistribute static
     network 10.90.0.0/16 area 0.0.0.1
    !
    access-list 20 permit 10.128.14.0 0.0.0.255
    access-list 20 deny any
    !
    line vty
    !
    
# Ospf Router B

## Настройки сети

    [root@centosuser ~]# ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN 
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
        link/ether 52:54:00:4e:ce:dc brd ff:ff:ff:ff:ff:ff
        inet 10.90.140.232/16 brd 10.90.255.255 scope global eth0
    3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
        link/ether 52:54:00:71:29:1c brd ff:ff:ff:ff:ff:ff
        inet 192.168.11.3/16 brd 192.168.255.255 scope global eth1
    4: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN 
        link/ether 82:cf:f5:7a:ee:34 brd ff:ff:ff:ff:ff:ff
        inet 10.128.0.0/32 brd 10.128.0.0 scope global dummy0

## zebra.conf

    !
    ! Zebra configuration saved from vty
    !   2015/05/25 18:52:38
    !
    hostname c10_90_140_232
    log file /var/log/quagga/zebra.log
    !
    debug zebra events
    debug zebra packet
    debug zebra kernel
    debug zebra rib
    !
    interface dummy0
     ipv6 nd suppress-ra
    !
    interface eth0
     ipv6 nd suppress-ra
    !
    interface eth1
     ipv6 nd suppress-ra
    !
    interface lo
    !
    interface ppp0
     ipv6 nd suppress-ra
    !
    ip forwarding
    !
    !
    line vty
    !

## ospfd.conf

    !
    ! Zebra configuration saved from vty
    !   2015/05/25 18:52:38
    !
    log file /var/log/quagga/ospfd.log
    log stdout
    !
    debug ospf event
    !
    !
    interface dummy0
    !
    interface eth0
    !
    interface eth1
    !
    interface lo
    !
    router ospf
     ospf router-id 10.90.140.232
     log-adjacency-changes
     redistribute connected
     redistribute kernel
     redistribute static
     passive-interface dummy0
     network 10.90.0.0/16 area 0.0.0.1
    !
    access-list 20 permit 10.128.14.0 0.0.0.255
    access-list 20 deny any
    !
    line vty
    !
