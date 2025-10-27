case "$-" in
	*i*)
		set -o vi
		alias pd=pushd
		alias dv="dirs -v"

		trap 'history -w ~/.local/share/bash_history' EXIT
		PROMPT_COMMAND='echo -ne "\033]0;$PWD\007";history -a;'$PROMPT_COMMAND
		HISTSIZE=100000
		HISTFILESIZE=1000000
		test -r ~/.local/share/bash_history && test $(wc -l <~/.local/share/bash_history) -gt $(history | wc -l) && history -r ~/.local/share/bash_history
		;;
esac

export TZ=Europe/Berlin
export TERM=rxvt-256color
export TERMINAL=urxvt
export PAGER="/usr/bin/less"
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
