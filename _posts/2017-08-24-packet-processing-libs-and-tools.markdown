---
title: Сравнение библиотек и утилит для обработки PCAP-файлов
---

Задача: разбивать PCAP файлы по TCP-потокам. Я перепробовал несколько решений для этого.

| Фича | Scapy | Tshark + lua | dpkt | pyshark | tcpflow | pcap-flow |
| :---- | :----: | :----: | :----: | :----: | :----: | :----: |
| **Поддержка отладки** | 4/5. Даёт пользователю интерпретатор на основе ipython с автодополнением. |  2/5. Документация среднего качества, если LUA не знаком - тяжело. Единственный способ отладки - принты. | 3/5. Любой отладчик python-кода. | 4/5. Любой отладчик python-кода. Очень крутой pretty print | ? |  ? |
| **Поддержка TLS** | 2/5. Не умеет. Есть проект scapy tls layers, у него много проблем на MacOS и CentOS | 5/5. Замечательно справляется, понимает семантику расширений. | 4/5. Определить тип пакета (ClientHello) может, но не понимает семантику расширений.| 5/5. Прозрачно наследует все возможности wireshark | 1/5. Не умеет, но ему и не нужно | 1/5. Не умеет, но ему и не нужно |
| **Архитектурная простота** | 3/5. Огромная вещь в себе. | 5/5. Встроенный скриптовый язык, все возможностей wireshark. | 4/5. Костылями с github удалось добавить понимание расширений TLS. | 5/5 - вывод `tshark -V` парсится в объекты очень изящно | не знаю | 4/5 - пара файлов на C. |
| **Сложность установки** | 3/5. Ставится через pip легко, часто падал с ошибками в MacOS/CentOS 6. Юзал py2.7. У людей из интернета всё отлично, мб я такой. | 4/5. На большинстве современных машин поддержка lua включена по умолчанию. Для CentOS 6 необходимо пересобирать RPM'ку (--with-lua) и при использовании только rpmbuild получаем большое число ошибок сборки. `autoreconf && ./configure && make` помогают. | 5/5. `pip install dpkt` | 5/5. `pip install pyshark` | 5/5. `brew install tcpflow` | 4/5. Поддерживается только современный Linux, требует glibc 2.14 и gcc 4.6. |
| **Понимание tcp-stream** | - | - | + | + | ? | ? |
| **Запись в PCAP** | - | + | - | - | - | + |
| **Генерация и отправка пакетов** | + | - | ? | - | - | - |

## Что выбрал?

Остановился на tshark + lua, решение [выложил на github](https://github.com/strizhechenko/tshark-tcp-stream-splitter).

Единственная проблема, которую я не решил до конца - утечка файловых дескрипторов. Можно по идее кэшировать их в памяти, но я и без этого не понимаю как обратиться к пакету и сохранить его или указатель на него в памяти в каком-нибудь, например списке. 8192 дескрипторов не хватает на 283мб PCAP от одного пользователя, где-то на 960000м пакете дескрипторы кончаются. Маловероятно, что у него было действительно 8к одновременных сессий.
