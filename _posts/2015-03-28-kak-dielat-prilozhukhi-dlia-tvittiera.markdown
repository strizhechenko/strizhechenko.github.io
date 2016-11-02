---
layout: post
title: "Как делать приложухи для твиттера"
date: '2015-03-28 10:02:51'
tags:
- python
- twitter
- bot
- tweepy
---

1. Зарегать приложуху тут https://apps.twitter.com/app/new. Скорее всего понадобится привязка к номеру мобильного телефона, увы и ах.
- Получаем Consumer Key и Consumer Secret
- Ищем подходящую либу, например tweepy
- Авторизуемся по гайду http://habrahabr.ru/post/127237/. Гайд вообще хороший, но я для себя упрощал всё сильно, оставив только функцию отправки твита: https://github.com/strizhechenko/simple_twibot
- После авторизации получаем access_key и access_secret.
- Ну и по аналогии делаем какую-нибудь приложуху уже, тут без мозга никак.
- На CentOS 6 с tweepy почему-то всё плохо, я тупо скопировал папку с Ubuntu 10.04.