case "$-" in
	*i*)
		set -o vi

		trap 'history -w ~/.local/share/bash_history' EXIT
		PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
		HISTSIZE=100000
		HISTFILESIZE=1000000
		;;
esac

export TZ=Europe/Berlin
export TERM=rxvt-256color