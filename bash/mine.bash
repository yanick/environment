
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


###########################
# Misc 
###########################

# create the dir and move in it
function ccd { 
    mkdir -p $1 && cd $1 
}

# Perl 
###########################

# perlbrew
source $HOME/perl5/perlbrew/etc/bashrc

# taken from http://use.perl.org/~domm/journal/40039
sack () {
    ack "sub $1" lib
}

complete -C perldoc_complete perldoc
complete -C perldoc_complete pod


# aliases
source ~/.bashrc/aliases
