---
layout: post
title: ntpdate stucks centos
date: '2015-07-04 06:19:09'
---

Не знаю как у нормальных людей, а у меня CentOS после установки ntpdate в систему вешает загрузку. В логах позже нашёл записи:

    Error resolving server: Name or service not known (-2)
     4 Jul 09:07:41 ntpdate[16915]: Can't find host server: Name or service not known (-2)
 
Решение оказалось довольно странным - в файле **/etc/ntp/step-tickers** удалить слова "server" и "iburst":

Было:

	server 0.centos.pool.ntp.org iburst
	server 1.centos.pool.ntp.org iburst
	server 2.centos.pool.ntp.org iburst
	server 3.centos.pool.ntp.org iburst

Стало:

    0.centos.pool.ntp.org
    1.centos.pool.ntp.org
    2.centos.pool.ntp.org
    3.centos.pool.ntp.org
