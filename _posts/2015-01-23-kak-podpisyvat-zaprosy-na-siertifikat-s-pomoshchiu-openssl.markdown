---
layout: post
title: "Как подписывать запросы на сертификат с помощью openssl"
date: '2015-01-23 07:00:53'
tags:
- carbon_billing
- asr_fiscal
---

	chroot /app/asr_fiscal
    openssl ca -config /cfg/cert/cert.cfg -cert /cfg/cert/ca.crt -keyfile /cfg/cert/ca.key -in /root/request_from_human.csr -out /root/cert_for_human.crt