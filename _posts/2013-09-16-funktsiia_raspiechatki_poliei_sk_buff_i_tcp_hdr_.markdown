---
layout: post
title: "Функция распечатки полей sk_buff и tcp_hdr."
date: '2013-09-16 06:02:00'
tags:
- linux_kernel
- net
- prink_sk_buff
- diebagh
- raspiechatka_tcp_hdr
---

Возможно кому-то окажется полезным при дебаге модулей в /net/

    static void print_skb_stuff(const struct sk_buff *skb)
    {
        struct tcphdr _tcph;
        const struct tcphdr *tcph;
    
        tcph = skb_header_pointer(skb, ip_hdrlen(skb),
                sizeof(_tcph), &_tcph);
    
        printk("syn=%u ack=%u psh=%u fin=%u seq=%u ack_seq=%u skb->len %u csum=%x\n",
            tcph->syn,
            tcph->ack,
            tcph->psh,
            tcph->fin,
            ntohl(tcph->ack_seq),
            ntohl(tcph->seq),
            skb->len,
            tcph->check
        );
        return;
    }
