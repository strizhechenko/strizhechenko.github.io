---
layout: post
title: "Интересный и простой способ показывать help в bash-скриптах."
date: '2013-06-04 05:19:00'
tags:
- bash
- help
- usage
- argparse
- optparse
---

Если в вашем bash-скрипте есть функция распарсивания опций с помощью case в самом начале скрипта, вроде этой:


``` shell
main() {
        case "${1:-}" in
                "" | "--help" | "-h" | "--usage" )
                        show_help
                        exit 0
                        ;;
                "--events-all" | "-all" | "-a" )
                        show_command_list_all $2
                        ;;
                "--events" | "-e" )
                        show_command_list $2
                        ;;
                "--user" | "-u" )
                        show_user $2
                        ;;
                "--firewall" | "--iptables" | "-f" )
                        show_iptables $2
                        ;;
                "--resolv" | "-r" )
                        shift
                        resolv_id_list $@
                        ;;
        esac
        return 0
}
```
то вы можете воспользоваться вот таким костылём:

``` shell
show_help() {
        grep -m1 -A 100 case $0 | grep esac -B 100 -m1 | egrep -v "(case|esac|;;)"
}
```

По крайней мере если вы писали этот код для себя, давали функциям осмысленные имена, то решение быстрое и приемлемое.
