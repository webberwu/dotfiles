#!/usr/bin/env bash

# npm (Node Package Manager) completion
# https://docs.npmjs.com/cli/completion
#
# `npm completion` 要跑 ~100ms，把結果 cache 起來。
# npm 執行檔比 cache 新時自動重建（升級 npm / 切 node 版本），不用手動清。

if command -v npm &>/dev/null
then
  _npm_comp_cache="$HOME/.cache/bash_completion/npm.bash"
  if [ ! -s "$_npm_comp_cache" ] || [ "$(command -v npm)" -nt "$_npm_comp_cache" ]; then
    mkdir -p "${_npm_comp_cache%/*}"
    npm completion > "$_npm_comp_cache" 2>/dev/null
  fi
  # shellcheck source=/dev/null
  . "$_npm_comp_cache"
  unset _npm_comp_cache
fi
