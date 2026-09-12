#!/usr/bin/env bash

# Docker Desktop 自帶 docker / docker-compose 的 bash 補全，跟著 Docker 版本走，
# 所以不再 vendor 一份 6,300 行的副本。
# Linux 上 docker 套件會裝到 /usr/share/bash-completion/completions/，
# 由 bash-completion framework 自動載入，這裡不用處理。
for _dc in /Applications/Docker.app/Contents/Resources/etc/docker{,-compose}.bash-completion; do
    # shellcheck source=/dev/null
    [ -f "$_dc" ] && . "$_dc"
done
unset _dc
