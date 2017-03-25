# vim: set ft=sh:
MOST=`which most`

case $(uname -s) in
    Linux)
        alias ls='ls --color=auto'
        alias la='ls -A'
        alias junipernc='junipernc -nojava'
        alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
        ;;
    Darwin|FreeBSD)
        alias ls="ls -GF"
        alias la="ls -AF"
        alias vi="vim"
        #enables color in the terminal bash shell export
        export CLICOLOR=1
        #sets up the color scheme for list export
        export LSCOLORS="ExfxcxdxbxEgEdabagacad"
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
alias docker-remove-unuse-volumes="docker volume rm $(docker volume ls -qf dangling=true)"
