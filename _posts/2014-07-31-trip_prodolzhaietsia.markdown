---
layout: post
title: "Трип продолжается"
date: '2014-07-31 15:13:00'
---

usage() {
&nbsp; &nbsp; &nbsp; &nbsp; echo "$0 [OPTIONS] &lt;nas_id&gt;"
&nbsp; &nbsp; &nbsp; &nbsp; grep "^# usage:" $0 | sed -e 's/# usage: //g'
&nbsp; &nbsp; &nbsp; &nbsp; echo "where OPTIONS is:"
&nbsp; &nbsp; &nbsp; &nbsp; grep -m1 -A 1000 "^parse_params" $0 | grep -B 1000 -m1 "^}" | grep ".*|.*)$" | tr '|' '-' | tr -d ')'
&nbsp; &nbsp; &nbsp; &nbsp; exit 1
}

parse_params() {        debug=0        verbose=0        upload=0        force=0        while [ "$#" -gt 0 ]; do                param="${1//-/}"                case "$param" in                        v | verbose )                                verbose=1                                shift ;;                        u | upload )                                upload=1                                shift ;;                        f | force )                                force=1                                shift ;;                        d | debug )                                debug=1                                PS4='+ ${BASH_SOURCE##*/} $LINENO:      '                                set -x                                shift ;;                        help | h | usage )                                usage                                ;;                        * )                                break                                ;;                esac        done        nas_id=$1}