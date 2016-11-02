---
layout: post
title: "Слишком много safemode за два дня"
date: '2015-01-18 06:06:14'
---

    #!/bin/bash

    dbdir=/app/asr_billing/var/db/
    [ -f $dbdir/billing.gdb.stop -o -f $dbdir/billing.gdb ] && echo No u ok && exit 15
    baddb="$(find $dbdir/bad/ -type f -name "*save_mode*.gdb"  | sort | tail -1)"
    cp -vp $baddb $dbdir/billing.gdb.stop
    /app/asr_billing/service restart
    if ! chroot /app/asr_billing /usr/local/bin/db_backup.sh; then
            echo "Total kaput (("
    fi 