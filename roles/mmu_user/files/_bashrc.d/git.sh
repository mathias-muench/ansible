. /usr/share/git-core/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=auto
GIT_PS1_SHOWCOLORHINTS=1
#PROMPT_COMMAND="__git_ps1 '' '$ '; $PROMPT_COMMAND"
PS1='$(__git_ps1 "(%s) ")\$ '
