use strict;
use warnings;

use Test::More;

use Test::File::Contents qw/ files_eq /;
use Path::Tiny;
use File::HomeDir;

files_eq path(File::HomeDir->my_home)->child('.tmux.conf')
    => 'tmux/tmux.conf' or diag 'vimdiff ~/.tmux.conf tmux/tmux.conf';

done_testing;




