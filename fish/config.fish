set fish_path $HOME/environment/oh-my-fish

set -g fish_color_host 00afff
set -g fish_color_user 005fff
set -g fish_color_cwd 00af00

set -x PERLBREW_ROOT /usr/local/soft/perlbrew/

. ~/.config/fish/perlbrew.fish

set fish_plugins autojump git 

. $fish_path/oh-my-fish.fish
