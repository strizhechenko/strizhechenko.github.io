---
layout: post
title: SSH долго подключается
date: '2013-07-12 12:08:00'
tags:
- ssh
- s_s_h2_m_s_g_s_e_r_v_i_c_e_a_c_c_e_p_t
- timeout
- usedns
- dolgho_podkliuchaietsia
---

Об этом писалось сотни раз, но мало ли, вдруг сто первый поможет решить проблему.

Запустите ssh к серверу с ключом -v
ssh -v user@host
если вы увидите, что наибольшее время проходит на этой строчке:
debug1: SSH2_MSG_SERVICE_ACCEPT received
то смело прописывайте в
/etc/ssh/sshd_config
параметр
UseDNS no
Если проблема сохраняется и после этого - можете попробовать отключить GSS Auth.