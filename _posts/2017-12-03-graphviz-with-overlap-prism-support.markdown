---
title: How to fix 'Overlap value "prism" unsupported - ignored'
tags: graphviz, sfdp, gv, map, prism, gts
---

## Problem

```
➜ brew install graphviz
➜ sfdp -Goverlap=prism x.dot | gvmap -e | neato -Ecolor=#55555522 -n2 -Tpng > x.png
Warning: Overlap value "prism" unsupported - ignored
Error: remove_overlap: Graphviz not built with triangulation library
Error: get_triangles: Graphviz built without any triangulation library

Assertion failed: (m > 0 && n > 0 && nz >= 0), function SparseMatrix_from_coordinate_arrays_internal, file SparseMatrix.c, line 843.
```

## Disclaimer

You'll need to build graphviz from sources.

## Solution

"correct" solution that didn't work because mess caused by moving graphviz to gitlab, maybe it will be fixed later.

```
brew install graphviz --with-gts
```

Workaround:

```
brew install gts
git clone https://gitlab.com/graphviz/graphviz.git
cd graphviz
./autogen.sh
./configure --with-gts
make -j 4
sudo make install
```
