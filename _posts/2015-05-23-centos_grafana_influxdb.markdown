---
layout: post
title: "Установка grafana + influxdb в CentOS 6"
date: '2015-05-23 07:09:41'
tags:
- centos
- influxer
- influxdb
- mac-os-x
---

Ссылки для новых версий:

- http://influxdb.com/download/
- http://grafana.org/download/

Собственно установка:

	yum -y install https://s3.amazonaws.com/influxdb/influxdb-latest-1.x86_64.rpm https://grafanarel.s3.amazonaws.com/builds/grafana-2.0.1-1.x86_64.rpm

	for service in grafana-server influxdb; do
    	chkconfig --level 345 $service on
        service $service restart
    done
    
В результате имеем:

## grafana

http://ip:3000/

admin / admin

## influxdb

http://ip:8083/

root / root

гадить в базу можно с помощью curl на 8086 порту.