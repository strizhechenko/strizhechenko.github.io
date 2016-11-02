---
layout: post
title: "В баше есть охуенный трап"
date: '2015-07-22 10:01:31'
---

    oleg@macbook:~ $ trap 'echo "VARIABLE-TRACE> \$variable = \"$variable\""' DEBUG
    VARIABLE-TRACE> $variable = ""
    oleg@macbook:~ $ variable=10
    VARIABLE-TRACE> $variable = ""
    VARIABLE-TRACE> $variable = "10"
    oleg@macbook:~ $ variable=$((variable+variable)) && variable=0
    VARIABLE-TRACE> $variable = "10"
    VARIABLE-TRACE> $variable = "20"
    VARIABLE-TRACE> $variable = "0"
