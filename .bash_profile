# vim: set ft=sh:
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# from https://github.com/Bash-it/bash-it/tree/master/completion/available
if [ -d "$HOME/.bash_completion.d" ] ; then
    for bcfile in `ls "$HOME/.bash_completion.d/"` ; do
        . "$HOME/.bash_completion.d/$bcfile"
    done
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.composer/vendor/bin" ] ; then
    PATH="$HOME/.composer/vendor/bin:$PATH"
fi

if [ -x "$(command -v brew)" ] && [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
fi
