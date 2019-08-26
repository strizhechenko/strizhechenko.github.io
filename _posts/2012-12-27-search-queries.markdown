---
layout: post
title: "Запросы по которым находят мой блог и ответы на них"
date: '2012-12-27 02:25:00'
tags:
- SEO
- блог
- запросы
- ответы
---

Посмотрел статистику, оказывается многие приходят на мой блог за ответами на вопросы, которых здесь нет. Попробую здесь на них ответить.

К слову - всё что касается продуктов Carbon Soft лучше искать в [документации](https://docs.carbonsoft.ru).

## Как сделать свою сборку Ubuntu

Я когда-то собирал свою сборку Ubuntu 10.04, но потерял эту статью при одном из переездов блога. Увы, прошло 9 лет, я ничего не помню.

## **Запрет доступа к сайтам Linux**

Купите [Carbon Reductor DPI X](https://www.carbonsoft.ru/products/carbon-reductor/). Он быстрый, известный, разработан по большей части мной.

## Carbon Reductor бесплатно

Это уж слишком.

## Установка сервера виртуализации на centos 6.3 virt-manager

Написал об этом [статью](https://strizhechenko.github.io/2012/12/18/podnimaiem_siervier_virtualizatsii_na_centos_6_3_libvirt_.html).

## Виртуализация kvm centos гигабит

Видимо имелась в виду возможность создания виртуальных гигабитных сетевых карт. Это делается строчкой:

``` shell
--network bridge=br0,model='e1000'
```

- e1000 означает модель эмулируемой сетевой карты
- br0 - мост, внутри которого будет находится создаваемый интерфейс
  (внутри моста также должен быть реальный гигабитный сетевой интерфейс)
  
## virsh install centos

Наверное имелось в виду `virt-install`, а не `virsh install`.

Вот пример использования:

``` bash
virt-install \
	-n centos \
	-c /storage/iso/centos6.iso \
	-r 1024 \
	--vcpus=2 \
	--os-type=linux \
	--os-variant=generic26 \
	--network bridge=br0,model=e1000 \
	--disk path=/qemu/img/centos6.img,size=25,format=qcow2,cache=writeback
```

## Centos - очень большое окно консоли виртуальной машины

Явно укажите в GRUB графический режим. Ключевые слова для поиска: "Grub Vga Modes".
