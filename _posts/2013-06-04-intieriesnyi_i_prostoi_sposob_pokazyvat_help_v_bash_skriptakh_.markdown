---
layout: post
title: "Интересный и простой способ показывать help в bash-скриптах."
date: '2013-06-04 05:19:00'
tags:
- bash2
- help
- usage
- vyvod_podskazki
- parsingh_optsii
- pomoshch_
- spravka
---

Если в вашем bash-скрипте есть функция распарсивания опций с помощью case в самом начале скрипта, вроде этой:opts_parse() {        if [ "$#" = '0' ]; then                show_help                exit 0        fi        case "$1" in                "--help" | "-h" | "--usage" )                        show_help                        ;;                "--events-all" | "-all" | "-a" )                        show_command_list_all $2                        ;;                "--events" | "-e" )                        show_command_list $2                        ;;                "--user" | "-u" )                        show_user $2                        ;;                "--firewall" | "--iptables" | "-f" )                        show_iptables $2                        ;;                "--resolv" | "-r" )                        shift                        resolv_id_list $@                        ;;        esac}то вы можете воспользоваться вот таким костылём:show_help() {        grep -m1 -A 100 case $0 | grep esac -B 100 -m1 | egrep -v "(case|esac|;;)"}По крайней мере если вы писали этот код для себя, то решение быстрое и понятное (если вы конечно называете функции адекватно, а не "котик()", "пусичка()", "няшечка()", "show()" итд).