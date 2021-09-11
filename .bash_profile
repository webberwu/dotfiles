# vim: set ft=sh:
# if running bash
if [ -n $BASH_VERSION ]; then
    # include .bashrc if it exists
    if [ -f $HOME/.bashrc ]; then
        . $HOME/.bashrc
    fi
fi

# from https://github.com/Bash-it/bash-it/tree/master/completion/available
if [ -d $HOME/.bash_completion.d ] ; then
    for bcfile in `ls $HOME/.bash_completion.d/` ; do
        . $HOME/.bash_completion.d/$bcfile
    done
fi

if [ ! -z `command -v brew` ] && [ -d `brew --prefix`/etc/bash_completion.d ]; then
    source `brew --prefix`/etc/bash_completion.d/*
    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_NO_INSTALL_CLEANUP=1
    export PATH="/opt/homebrew/bin:$PATH"
fi

[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.fzf/shell/key-bindings.bash ] && source ~/.fzf/shell/key-bindings.bash

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
