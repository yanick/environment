use strict;
use warnings;

use Test::More;

use Test::Files;
use Test::File::Contents;

compare_ok "$ENV{HOME}/.vim/plugin/zencoding.vim" => 'zencoding-vim/zencoding.vim'
    or diag "cp zencoding-vim/zencoding.vim $ENV{HOME}/.vim/plugin";


done_testing();

