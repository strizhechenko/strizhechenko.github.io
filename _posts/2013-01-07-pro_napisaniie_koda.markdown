---
layout: post
title: "Про написание кода"
date: '2013-01-07 11:13:00'
tags:
- soviety_dlia_razrabotchikov
- vielosipiedy
- kostyli
- pishiem_bash_completion_dlia_virsh
- pol_za_poiskovykh_sistiem
---

Сейчас произошла дурацкая ситуация: поскольку я часто использую [virsh](http://manpages.debian.net/cgi-bin/man.cgi?sektion=1&amp;query=virsh&amp;apropos=0&amp;manpath=sid&amp;locale=en)&nbsp;(кстати странно, но я почти ни разу не видел хорошего описания virsh на русском языке, хотя вещь более чем охренительная), мне захотелось дотабывать. А в стандартной поставке (по крайней мере в centos 6.3 и в ubuntu 10.04.4) bash_completion'а не было.

<a name="more"></a>
Что делает хорошо воспитанный благородный программист, который ценит своё время, которое может потратить на близких, либо на написание переворачивающих мир вещей, ну в общем адекватнейший человек в таких ситуациях? **Гуглит не написано ли оно уже**, и только после этого открывает vim, а не наоборот как я.

Оказывается отличнейший bash_completion был уже написан неким&nbsp;Serge E. Hallyn, которому я несказанно благодарен. Вот ссылка:
[http://www.redhat.com/archives/libvir-list/2011-October/msg00141.html](http://www.redhat.com/archives/libvir-list/2011-October/msg00141.html)

А вот костыль написанный мной, поленившимся погуглить:

[https://github.com/hordecore/configs/blob/master/virsh](https://github.com/hordecore/configs/blob/master/virsh)

Ну, нет конечно худа без добра, я научился bash_completion писать, но всё равно, сейчас нахожусь в немного берсерковатом состоянии.