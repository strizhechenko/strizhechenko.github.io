---
layout: post
title: "Мой способ палить ветку git репозитория в которой нахожусь"
date: '2014-05-12 06:55:00'
tags:
- git
- bashrc
- branch
---

get_git_dir() {
        tmp=$PWD
        while [ -n "$tmp" ]; do
                [ -d $tmp/.git ] && echo $tmp && return 0
                tmp=${tmp%/*}
        done
}
parse_git_branch() {
        git_dir="$(get_git_dir)"
        [ -z "$git_dir" ] && return 0
        repo="$(grep -o /.*.git "$git_dir"/.git/config | cut -d '.' -f1 | tr -d '/')"
        [ "${PWD##*/}" = "$repo" ] && repo='' || repo=" $repo"
        branch="$(cd $git_dir; git branch)"
        echo "$repo (${branch#\* })"
}
PS1='[\u@x($?) \W`parse_git_branch`]\$ '
Эти строки надо добавить в ~/.bashrcПо идее бы ещё показывать dirty ветка или нет.