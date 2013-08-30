# vim: set ft=sh:
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
alias composer='php -d allow_url_fopen=On ~/bin/composer.phar'
