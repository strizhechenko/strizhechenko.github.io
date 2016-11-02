---
layout: post
title: Carbon Billing 5 on CentOS 6
date: '2014-12-22 13:33:20'
tags:
- carbonsoft
- carbon-billing-5
- carbon-reductor
---

Теперь Carbon Billing 5 устанавливается, работает и более того, нормально обновляется и работает после этого на CentOS 6.

Для этого мне пришлось избавиться от множества посягательств base на корневую файловую систему, теперь они минимальны, но со временем и они будут уничтожены.

Пока всё завелось, конечно, с пинками, но пара тестовых установок, я думаю, выявит все проблемы с этим.

Установщик можно пронаблюдать [здесь](https://github.com/carbonsoft/carbon_scripts/blob/master/install_on_centos.sh). Для запуска по сути достаточно просто установить CentOS 6.3 - 6.5 (на 6.6 и выше не тестировал, но может и заведётся), настроить на нём сеть и выполнить.

	curl -L https://raw.githubusercontent.com/carbonsoft/carbon_scripts/master/install_on_centos.sh > install.sh
    bash install.sh Billing oleg cur
    


![Пруф:](/content/images/2014/12/--------------2014-12-23---10-50-17.png)
