---
layout: post
title: "Профилируем python-скрипты"
date: '2015-03-08 14:17:08'
---

``` shell
code="mine.py"
sudo pip install graphviz gprof2dot
python -m cProfile -o profile.pstats "$code"
gprof2dot -f pstats profile.pstats | dot -Tsvg -o mine.svg
```

На выходе имеем:

![на выходе](/content/images/2015/03/mine.svg)
