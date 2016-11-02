---
layout: post
title: "Щупаем Prometheus (0.15)"
date: '2015-07-16 19:36:28'
---

	git clone https://github.com/prometheus/prometheus.git
	cd prometheus
	[root@prometheus prometheus]# make
    curl -o /root/prometheus/.build/cache/go1.4.2.linux-amd64.tar.gz -L https://golang.org/dl/go1.4.2.linux-amd64.tar.gz
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
     37 59.5M   37 22.5M    0     0   283k      0  0:03:34  0:01:21  0:02:13  355k
 
Но ведь.. yum -y install golang же?

    TMPDIR=/tmp GOROOT=/root/prometheus/.build/root/go GOPATH=/root/prometheus/.build/root/gopath /root/prometheus/.build/root/go/bin/go test -short ./...

И моментально получают большой плюс.

    [root@prometheus prometheus]# make install
    make: *** Нет правила для сборки цели `install'.  Останов.

а после этого сразу минус.