# vim: set ft=sh:
# if running bash
if [ -n $BASH_VERSION ]; then
    # include .bashrc if it exists
    if [ -f $HOME/.bashrc ]; then
        . $HOME/.bashrc
    fi
fi

# 用 [ -x ] 探測 brew 前綴，取代 `brew --prefix`（每次 ~30ms，原本被呼叫 4 次）
if [ -z "$HOMEBREW_PREFIX" ]; then
    for _hb in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do
        if [ -x "$_hb/bin/brew" ]; then export HOMEBREW_PREFIX="$_hb"; break; fi
    done
    unset _hb
fi

# from https://github.com/Bash-it/bash-it/tree/master/completion/available
if [ -d $HOME/.bash_completion.d ] ; then
    for bcfile in `ls $HOME/.bash_completion.d/` ; do
        . $HOME/.bash_completion.d/$bcfile
    done
fi

if [ -n "$HOMEBREW_PREFIX" ]; then
    # 原本這行是 `source `brew --prefix`/etc/bash_completion.d/*`，但 source 只吃第一個參數
    # （其餘變成 positional params），實際上只載入了字母序第一個檔 ag.bashcomp.sh。
    # 這裡維持原本的實際行為；全部 20 個檔都載入要多付 ~60ms。
    [ -r "$HOMEBREW_PREFIX/etc/bash_completion.d/ag.bashcomp.sh" ] && \
        . "$HOMEBREW_PREFIX/etc/bash_completion.d/ag.bashcomp.sh"
    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_NO_INSTALL_CLEANUP=1
    export PATH="$HOMEBREW_PREFIX/bin:$PATH"
fi

[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

[ -d $HOME/bin ] && export PATH=$HOME/bin:$PATH
[ ! -z `command -v yarn` ] && export PATH=$PATH:`yarn global bin`
[ -d $HOME/.composer/vendor/bin ] && export PATH=$HOME/.composer/vendor/bin:$PATH
[ -d $HOME/.config/composer/vendor/bin ] && export PATH=$HOME/.config/composer/vendor/bin:$PATH

if [ ! -z $(command -v go) ]; then
    [ -d /usr/local/opt/go/libexec/bin ] && export PATH=$PATH:/usr/local/opt/go/libexec/bin
    export GO111MODULE=on
    export GOPATH=$(go env GOPATH)
    export PATH=$PATH:$(go env GOPATH)/bin
fi

# nvm lazy load: source nvm.sh 要 ~225ms。平常只把 default 版本的 bin 加進 PATH
# (路徑 cache 在 ~/.cache/nvm_default_bin)，第一次呼叫 nvm 才真正載入。
# 只有 $NVM_DIR/alias/default 比 cache 新時會重新解析，那次才付一次 225ms。
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    _nvm_cache="$HOME/.cache/nvm_default_bin"
    if [ -s "$_nvm_cache" ] && [ ! "$NVM_DIR/alias/default" -nt "$_nvm_cache" ]; then
        export PATH="$(cat "$_nvm_cache"):$PATH"
        nvm() {
            unset -f nvm
            \. "$NVM_DIR/nvm.sh"
            [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
            nvm "$@"
        }
    else
        \. "$NVM_DIR/nvm.sh"   # nvm.sh 自己會把 default 版本設進 PATH
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        mkdir -p "${_nvm_cache%/*}"
        dirname "$(nvm which default)" > "$_nvm_cache" 2>/dev/null
    fi
    unset _nvm_cache
fi
