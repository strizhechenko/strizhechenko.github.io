---
layout: post
title: "Профилируем python-скрипты"
date: '2015-03-08 14:17:08'
---

    sudo pip install graphviz
    sudo pip install gprof2dot
    python -m cProfile -o profile.pstats mine.py
    gprof2dot -f pstats profile.pstats | dot -Tsvg -o mine.svg

На выходе имеем:
![на выходе](/content/images/2015/03/mine.svg)