#!/usr/bin/env bash

# kubectl (Kubernetes CLI) completion
#
# 第一次按 Tab 才產生／載入補全。
# kubectl 執行檔比 cache 新時自動重建（brew upgrade 後），不用手動清。
#
# 補全函式回傳 124 是 bash 的約定：表示 compspec 已更換，請重跑一次補全。

if command -v kubectl &> /dev/null
then
  _kubectl_comp_load() {
    local cache="$HOME/.cache/bash_completion/kubectl.bash"
    if [ ! -s "$cache" ] || [ "$(command -v kubectl)" -nt "$cache" ]; then
      mkdir -p "${cache%/*}"
      kubectl completion bash > "$cache" 2> /dev/null
    fi
    # shellcheck source=/dev/null
    . "$cache"                      # 這會重新註冊 complete -F __start_kubectl kubectl
    unset -f _kubectl_comp_load
    return 124
  }
  complete -F _kubectl_comp_load kubectl
fi
