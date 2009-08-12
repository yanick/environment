###########################
# Git 
###########################

export GIT_EDITOR=vim
source ~/.bash/git-completion.bash
PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
