---
title: Ещё более тупой пример ospf
---

## Задача

Отдать с хоста 2 на хост 1 информацию о том, что хост 2 имеет роут до сети 192.168.39.0/24

**Задач по безопасности и правильности перед нами не стоит.**

## Хост 1

```
[root@ospf1 ~]# ip -4 a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
    inet 127.0.0.1/8 scope host lo
2: venet0: <BROADCAST,POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN
    inet 127.0.0.1/32 scope host venet0
    inet 10.50.4.101/32 brd 10.50.4.101 scope global venet0:0
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN
    inet 192.168.37.1/24 brd 192.168.37.255 scope global eth1
```

```
cat /etc/quagga/zebra.conf
hostname ospf1
log file /var/log/quagga/zebra.log
ip forwarding
line vty
```

```
cat /etc/quagga/ospfd.conf
hostname ospf1
log file /var/log/quagga/ospfd.log
router ospf
 ospf router-id 192.168.37.1
 network 192.168.37.0/24 area 0.0.0.1
line vty
```

## Хост 2

```
[root@ospf2 ~]# ip -4 a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
    inet 127.0.0.1/8 scope host lo
2: venet0: <BROADCAST,POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN
    inet 127.0.0.1/32 scope host venet0
    inet 10.50.4.102/32 brd 10.50.4.102 scope global venet0:0
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN
    inet 192.168.37.2/24 brd 192.168.37.255 scope global eth1
    inet 192.168.39.2/24 scope global eth1
```
```
[root@ospf2 ~]# cat /etc/quagga/zebra.conf
hostname ospf2
log file /var/log/quagga/zebra.log
ip forwarding
line vty
```
```
[root@ospf2 ~]# cat /etc/quagga/ospfd.conf
hostname ospf2
log file /var/log/quagga/ospfd.log
router ospf
 ospf router-id 192.168.37.2
 redistribute connected
 network 192.168.37.0/24 area 0.0.0.1
line vty
```

## Советы

- проверьте доступность хостов между друг другом с помощью ping
- проверьте, что оба высылают OSPF Hello с помощью tcpdump / tshark
- проверьте, что оба получают высланные друг другом OSPF Hello
    - тут есть нюанс, это multicast, так что прилетать будет src=ip-отправителя dst=224.0.0.x
- проверить, что роут прилетел можно с помощью `ip r`
- включить дебаг - это добавить в конфиг ospf `debug ospf events`
