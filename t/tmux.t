use strict;
use warnings;

use Test::More;

use Test::File::Contents qw/ files_eq /;
use Path::Tiny;
use File::HomeDir;

my( $version ) = `tmux -V` =~ /(\d+\.\d+)/;
cmp_ok $version, '>=', 1.8, "version >= 1.8";

files_eq path(File::HomeDir->my_home)->child('.tmux.conf')
    => 'tmux/tmux.conf' or diag 'vimdiff ~/.tmux.conf tmux/tmux.conf';

done_testing;




