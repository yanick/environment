
# me <3 vim
export EDITOR=vim
export SVN_EDITOR=$EDITOR
export GIT_EDITOR=$EDITOR

################################
# ssh
###############################
function sshdel { perl -i -ne "print unless \$. == $1" ~/.ssh/known_hosts; }

###########################
# Git 
###########################

source ~/.bash/git-completion.bash
PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
