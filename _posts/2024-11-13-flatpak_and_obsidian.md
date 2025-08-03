---
title: Обрезаем Obsidian разрешения
---

Где-то года полтора использую Obsidian уже и осознал, что не сильно-то я ему и доверяю.

Поспрашивал людей в mastodon, погуглил сам - как бы обрезать ему доступ в сеть и ограничить доступ к файловой системе?

Причём желательно максимально стандартным способом (в порядке приоритета - встроенные средства flatpak, selinux/apparmor, сторонние инструменты).

Flatseal скорее всего просто надстройка над override, которая наверное даже работает, но всё же сторонний инструмент, который тащить к себе не хочется.

Хмм! - сказали мужики и попробовали:

``` shell
flatpak --user override --unshare=network --unshare=ipc com.obsidian.Obsidian
```

А при нажатии на кнопочку проверить обновления трафик в tpcdump всё равно появлялся.

Окей! - сказали мужики и попробовали:

``` shell
sudo flatpak override --unshare=network --unshare=ipc com.obsidian.Obsidian
```

Файлик с override где-то в `/var` появился, но в сеть obsidian продолжил уметь ходить почему-то.

Ага! - сказали мужики и попробовали:

``` shell
sudo vim /var/lib/flatpak/app/md.obsidian.Obsidian/current/active/metadata
```

и поправили секцию Context:

``` ini
[Context]
# shared=network;ipc;
# sockets=x11;wayland;pulseaudio;ssh-auth;
# filesystems=home;/media;xdg-run/gnupg:ro;/mnt;/run/media;xdg-run/app/com.discordapp.Discord:create;
# persistent=~/.ssh;

sockets=x11;wayland;
devices=dri;
filesystems=/path/to/my/vault/;
```

и всё заработало как надо.

## Зачем?

Спится спокойнее.
