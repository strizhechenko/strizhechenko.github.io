---
layout: post
title: "Проброс X по SSH перестаёт работать после отключения ipv6."
date: '2014-02-11 09:49:00'
---

Жесть. Отключил поддержку [<s style="color: #66c1c1; text-decoration: none;">#</s>**ipv6**](https://twitter.com/search?q=%23ipv6&amp;src=hash) на рабочем компе, после ребута остался без проброса [<s style="color: #66c1c1; text-decoration: none;">#</s>**X**](https://twitter.com/search?q=%23X&amp;src=hash)'ов по [<s style="color: #66c1c1; text-decoration: none;">#</s>**SSH**](https://twitter.com/search?q=%23SSH&amp;src=hash).  Однако включение AddressFamily inet в sshd_config помогло.