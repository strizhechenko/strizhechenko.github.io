---
layout: post
title: "Использование heroku: пример с twitter ботом"
date: '2016-03-08 04:37:45'
tags:
- twitter
- tweepy
- twitterbot-utils
- bots
- heroku
---

Все примеры подразумевают использование Python.

## Регистрация на Heroku

1. [Регистрируемся на heroku](http://heroku.com/).
2. Идём по [гайду](https://devcenter.heroku.com/articles/getting-started-with-python#introduction), устанавливаем утилиты от heroku.

## Конфигурация

В heroku конфигурацию принято хранить в окружении.

1. Задаём параметры командой: `heroku config:set variable="value"`. Не забудьте кавычки, особенно если в значении есть пробелы.
2. В коде получаем доступ к ним с помощью `os.getenv('variable')`

## Пример бота

``` shell
git clone https://github.com/strizhechenko/twitterbot_example.git
```

Содержимое репозитория:

- `Procfile` - объясняет какой командой запускать бота;
- `runtime` - какая среда (читай версия python) нужна для запуска бота;
- `requirements.txt` - все зависимости бота;
- `bot.py` - код бота;
- `morpher.py` - вспомогательный модуль для нормализации русскоязычных существительных.

## Конфигурация

Я обычно использую в качестве словаря бота не файл или базу, а собственную ленту твиттера. Для этого нужна авторизация под несколькими пользователями:

* самого бота - `user_access_token` и `user_access_secret`
* читателя - `strizhechenko_access_token` `strizhechenko_access_secret`

Просмотр конфигурации:

``` shell
$ heroku config -s
template='%s – это когда тебя любят.'
timeout=30
```

## Регистрация приложения в твиттер

`consumer_key` и `consumer_secret` - можно получить зарегистрировав приложение здесь - https://apps.twitter.com/. Это идентификаторы вашего приложения, их лучше никому не знать, в публичный код его зашивать не надо.

## Авторизация пользователей

Авторизовать пользователей можно с помощью утилиты в `twitterbot_utils`:

``` shell
virtualenv env/
. env/bin/activate
pip install -r requirements.txt
export consumer_key=your_consumer_key
export consumer_secret=your_consumer_secret
python -m twitterbot_utils.TwiAuth
```

Утилита спросит PIN код, который будет показан в браузере, а затем отдаст: `access_token` и `access_secret`. Авторизовать надо и себя и бота, поэтому не забудьте перелогиниться в браузере.

Осталось два парметра  `template` и `timeout`:

``` shell
template='%s – это когда тебя любят.'
```

`template` - шаблон фразы, в которую будут подставлены существительные, работает как printf почти.

``` shell
timeout=30
```

`timeout` - интервал межд постингом, задаётся в минутах.

Есть ещё две необязательные опции:

``` shell
tweet_grab = 3
tweets_per_tick = 2
```

* `tweet_grab` - число твитов, которые подтягиваются из ленты reader'а для поиска существительных.
* `tweets_per_tick` - число твитов, которые бот постит за один раз.

## Deploy в heroku

Итак мы всё настроили, возможно слегка поправили код `bot.py`. Закомитьтесь, если что-то меняли:

``` shell
git add -p
git commit -m "блаблабла"
```

Меняем origin, репозиторий-пример с гитхаба нам больше не нужен.

```
git remote remove origin
heroku create yourbotname
git push heroku master
```

После `git push` heroku должен обнаружить питоновое приложение и собрать его из requirements.txt:

```
remote: -----> Python app detected
```

Закончиться всё должно:

```
remote: Verifying deploy... done.
```

## Запуск

``` shell
heroku scale worker=1
```

Дальше остаётся смотреть логи и чинить если что-то не работает:

``` shell
heroku logs -t
```

Перезапуск бота:

``` shell
heroku scale worker=0
heroku scale worker=1
```
