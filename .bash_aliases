# vim: set ft=sh:
MOST=`which most`

case $(uname -s) in
    Linux)
        alias ls='ls --color=auto'
        alias la='ls -A'
        ;;
    Darwin|FreeBSD)
        alias ls="ls -GF"
        alias la="ls -AF"
        alias vi="vim"
        ;;
esac

# syntax highlight with cat command
# pip install Pygments
if type pygmentize >/dev/null 2>&1; then
    alias ccat='pygmentize -O style=monokai -f console256 -g'
fi

alias tmux="tmux -2"
alias today="date '+%Y%m%d'"
alias h='history'
alias grep='grep --color=auto --exclude-dir=\.git --exclude=*\.swp'
alias g='grep -rin'
alias ll="ls -ahlF"
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias findswp="find . -name '*.swp'"
alias delswp="findswp; find . -name '*.swp' | xargs rm"
alias composer='php -d allow_url_fopen=On -d apc.enable_cli=off ~/bin/composer.phar'
# show mount list on docker container, usage: show-docker-mount <container_id> | jq .
alias docker-show-mounts="docker inspect -f '{{ json .Mounts }}'"
alias docker-show-unuse-volumes="docker volume ls -qf dangling=true"
alias docker-remove-unuse-volumes="docker volume ls -qf dangling=true | xargs docker volume rm"
