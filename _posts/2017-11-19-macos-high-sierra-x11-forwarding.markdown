---
title: Проблемы с форвардингом X11 в MacOS High Sierra и как их решать
---

## Проблема

Мне нужен был virt-manager чтобы потестировать установку нашего дистрибутива Linux руками. Как назло после обновления MacOS он сломался. Ранее было:

- XQuartz установленный через brew cask
- переехал с bash на zsh

## untrusted X11 forwarding setup failed: xauth key data not generated

``` shell
➜  ~ ssh -X -C servername
Warning: untrusted X11 forwarding setup failed: xauth key data not generated
```

Одна из первых рекомендаций с stackoverflow:

```
➜  ~ xauth generate :0
xauth:  file /Users/oleg/.Xauthority does not exist
xauth: (argv):1:  unable to open display ":0".
```

## Временный хак

Запускаем XQuartz вручную. Ставим его в фокус, выбираем в меню - программы - терминал, из этого терминала ssh -X -C servername чудесно работает и открывает всё что нужно.

## Как сделать его постоянным

Сравнить окружение в этих терминалах.

Пробовал:

```
export DISPLAY=:0
export X11_PREFS_DOMAIN=org.macosforge.xquartz.X11
```

Не помогло.

## Примечания

Если в терминале xquartz (xterm вроде) запустить zsh - проброс X'ов тоже отваливается.
