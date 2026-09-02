#!/usr/bin/env bash

# kubectl (Kubernetes CLI) completion
#
# `kubectl completion bash` 要跑 ~95ms，把結果 cache 起來。
# kubectl 執行檔比 cache 新時自動重建（brew upgrade 後），不用手動清。

if command -v kubectl &>/dev/null
then
  _kubectl_comp_cache="$HOME/.cache/bash_completion/kubectl.bash"
  if [ ! -s "$_kubectl_comp_cache" ] || [ "$(command -v kubectl)" -nt "$_kubectl_comp_cache" ]; then
    mkdir -p "${_kubectl_comp_cache%/*}"
    kubectl completion bash > "$_kubectl_comp_cache" 2>/dev/null
  fi
  # shellcheck source=/dev/null
  . "$_kubectl_comp_cache"
  unset _kubectl_comp_cache
fi
