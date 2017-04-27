---
title: Как создать задержку HTTP-запросов с помощью tc на шлюзе с Linux
---

Всё очень упрощённо, без подчистки за собой.

Мне нужно было добавить секундную задержку только для GET-запросов, чтобы установка соединения и последующий обмен ACK'ами не замедлялись.

```
#!/bin/bash

set -eu

IF="${1:-eth3}"
IFSPEED=1000Mbps
DELAY="${2:-1000ms}"
CLASS=11
ROOT=1

tc qdisc  add dev $IF handle $ROOT: root htb
tc class  add dev $IF parent $ROOT: classid $ROOT:$CLASS htb rate $IFSPEED
tc qdisc  add dev $IF parent $ROOT:$CLASS handle $CLASS: netem delay $DELAY
tc filter add dev $IF parent $ROOT:0 prio 1 protocol ip handle $CLASS fw flowid $ROOT:$CLASS
iptables -t mangle -A POSTROUTING -o $IF -p tcp --dport 80 -m string --string 'GET' --algo 'bm' -j MARK --set-mark $CLASS
```

