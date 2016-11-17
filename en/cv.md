---
layout: page
---

# Common info

Oleg Strizhechenko, 25 y.o. Developer: backend, linux, c, python, etc.

Location: Russia, Yekaterinburg. Looking to relocation.

Salary expectation: about 45000-80000€, depends of where to work.

# Contacts

## Coding related
- [codewars: ![codewars rating](https://www.codewars.com/users/strizhechenko/badges/micro)](https://www.codewars.com/users/strizhechenko)
- [github](https://github.com/strizhechenko)
- [habrahabr](http://habrahabr.ru/users/weirded)
- [linkedin](https://linkedin.com/in/strizhechenko)
- [blog about Linux](http://strizhechenko.github.io)

## Other
- [e-mail](mailto:oleg.strizhechenko+random@gmail.com)
- [twitter](https://twitter.com/strizhechenko)

# Education
- [http://uisi.ru/](http://uisi.ru/) - three years, technic (easily graduated with honors)
- [http://urfu.ru/](http://urfu.ru/) - four years, bachelor

# Languages

- Russian native
- English - secondary, I am taking an english courses now, current level - something about intermediate/upper-intermediate.

# Programming languages and skills, expirience.

## Projects

- Junior system administrator in few little companies (1 year, part time work).
- Tandem University - Univesities automation system. Q/A.
- Ideco ASR / Ideco AS / Carbon Billing 4 - linux based (2.4 kernel) softrouter and billing for little ISP (about 2000-10000 abonents). Q/A, support, developer.
- Linux distro (like CoreOS but with chroots instead of normal containers) and building system for Carbon Billing 5 based on CentOS 6. (developer)
- Carbon Billing 5 - billing for ISP with up to 100000 abonents. Frequently helping to neighbor team with some system/linux/network problems. (developer)
- Carbon XGE Router - linux based (2.6 kernel) softrouter with cool shapers, ipsets, easy to use with Carbon Billing 5 (main developer).
- Carbon Reductor - DPI and MitM for russian ISPs. Lead developer. Now it used by more than 350 ISP with 1000-100000 users.

# Skills

I just have some fun with graphviz recently so you can look at my "skill map": [SVG](/images/my-skills.svg) or [PNG](/images/my-skills.png).

## Main

### bash

- Good thing if code is fit to the screen and does not contain functions.
- Long time ago I have much expirience with using eval and unit-testing in shell but I do not want it again.
- toolchain: vim > atom, bash -eux, shellcheck

### python

- Tweepy - I like to make simple twitter-bots. Some time ago compiled common code in my wrapper  [github](https://github.com/strizhechenko/twitterbot_utils).
- Pymorphy2 - twitterbots sometimes require to generate russian texts, and this library can inflect russian words perfectly.
- Flask - the only thing I like to use in web development to minimize pain (I am not a web developer, but sometimes I need some small work with it). For example - mini-app that parse trolleybus arrival info: [bus.acidkernel.com](http://bus.acidkernel.com) ([github](http://github.com/strizhechenko/trolleybuses)).
- Flask-api - I love it for being simple and clean. Have used it as proxy between postgres and influxdb, used for analytic purpose.
- Qdns / dnspython - wrote multithreading dns resolver with smart cache + custom gethostsbyname call, that query every domain server used in system and sum up their resonses.
- Have expirience about parsing web-pages and using API of social networks (XML/JSON) and services like vk / twitter / uber / soundcloud.
- Toolchain: vim > atom > PyCharm CE, nosetests, pylint, ipython, cProfile.

### c

- Linux kernel, netfilter, iptables - realtime DPI and MitM for HTTP & DNS, works with 1-40gbit/s bandwidth. Know how to tune linux network stack up to top of its capabilities.
- Pf_ring - about 4-10 hours of experiments.
- Netflow processing - port from x86 to x86_64 one legacy-project about collect and aggregate netflow statistic, make some fixes to work with 5 and 9 netflow versions.
- Toolchain: vim > atom, cmocka, gcc/clang, clang-format, clang-check, gdb, strace, gprof, make, valgrind.

### linux

- I almost entirely understand everything about Linux network performance - (RPS, RRS, Coalesce/Buffer size, network cards choose, etc).
- I know much about utils for troubleshooting of network problems and server performance: iproute2, ethtool, ss, procps, bind-utils, top, iotop, oprofile, ftrace.
- Writing almost perfect shell-code, know my tools well (coreutils, grep, awk, sed, etc).
- Problem: currently stucked on RHEL6 cause company policy and want to real expirience with systemd and newer Linux systems.

### networks
I am working with 400+ ISP in russia for 5+ years as Q/A, support, developer and product owner now.

I have a little lack of systemized knowledge about specific equipment, but know much about realtime traffic analyzing, insides of popular protocols and very familliar with tcpdump/tshark.

Also I know capabilities and problems some network equipment can provide.

### sql/postgres
Recently, by influence of @backendsecret from twitter, I decided to touch postgres capabilities with json/jsonb queries.

Hard, uninteresting and terrible technical details part: In beginning I had markdown text, collected in bash-script, parsed it in python, convert it to json and put it in jsonb-field of postgres (raw data), exposed to analytic server by transparent backend writen with flask-api. "Analytic server" is influxdb and grafana, meh.

Weird, but task is done and I have gather my necessary information and statistic.

### influxdb / grafana / metrics
Use it about 2 years to collect and visualize data, commonly related to business, not tech (but it\'s too). Examples:

- data about paid bills of current project
- my estimated monthly wage
- bugs/problems statistic about servers of customers, used to prevent mass bug spread
- unit, functional and performance tests results from jenkins.
- uber prices for drive to home/work: [github](https://github.com/strizhechenko/uber_surge_alerter) :)

### CSS

- metroui.org.ua - never used anything else. That's rescued me from make very terrible web-interfaces, so I make just bad: [Carbon Reductor Web-UI](http://demo-reductor.carbonsoft.ru), [trolleybuses info](http://bus.acidkernel.com).

### Virtualisation

Active user, write much wrappers to deploy VM / containers. Know many about building tricky/efficient network communication and routing between them. Much exp in traffic capture and analyze.

- openvz
- lxc
- libvirt + qemu/kvm
- heroku (free account for twitterbots)

### Documentation
I like to create human oriented structurized documentation, FAQs and translations, that really helps to solve problems. Like rst and Markdown, wiki like a confluence. For example: [Carbon Reductor docs](http://docs.carbonsoft.ru/display/reductor5). Like to help guys from marketing to write press-releases about new version with new features descriptions on user language (have little worries that I bury this skill cause main language shift).

## Side Skills
- c++, java, php, javascript, go
- familiar with letsencrypt, openssl, uwsgi, nginx, redis

## Want to learn more
It\'s not about "solve 1-2 problems with stackoverflow", but about closely reading all the docs and about 200 hours of expirience with it.

- selinux
- graphite
- systemd
- netfilter of current version of Linux kernel and it\'s new capabilities
- ansible - love and frequently use it
- continuous queries in influxdb
- docker
- openstack
- write twitterbot with golang
- profiling and optimizing sql in postgres
- combining zabbix (as alerter) and influxdb
- tweepy twitter streaming api in twitterbot-utils
- python-midi (drums, other instruments, virtual midi controller, combine with garageband)
- gcov automation
- Kbuild и dkms insides
- right usage of pipelines in jenkins (now i use it only like a crond with web and history to run tests)
- oprofile usage for profile userspace applications
- nginx performance tuning (something deeper than just increase worker count and enable e-poll usage)
- finish read books about machine learning or continue stopped on 2nd week coursera courses from Andrew Ng

# Programming books I\'ve read

- The Pragmatic Programmer
- An Introducion to programming on Go
- The Mythical Man-Month
- Cord of enouth len for shooting your leg (have no idea of its english title)
- C Programming language
- Linux kernel primer
- Facts and Fallacies of Software Engineering
- Dive into python
- Clean code (Bob Martin)
- Agile technologies, Extreme Programming and RUP.
- The main question of coding, refactoring and everything.
- Human factor. Successful projects and commands.
- Scrum and XP, notes from frontline
- Extreme programming
- Advanced Bash Scripting Guide
- Linux Advanced Routing and Traffic Control
- Iptables Tutorial 1.1.19
- Unix in a nutshell
- Art of the Unix programming
- Advanced Linux programming
- Network Performance Tuning (Jamie Bainbridge and Jon Maxwell)

## Programming books I'm reading now

- SRE. How google runs production software.
- Introduction to machine learning with Python.

# OS I prefere:

- Local development: OS X / Fedora 24
- Servers: CentOS 6 / Centos 7

# Other info

- Twise was weekly author of [@kernelunderhood](https://twitter.com/kernelunderhood) - twitter about system programming.
- Curator of [@sorrowunderhood](https://twitter.com/sorrowunderhood) - collective twitter account  where programmers complaining about technologies.
- Like to create and listen to electronic music, visit theatres and concerts, watch sci-fi/cyberpunk/arthouse movies, retrogaming.
