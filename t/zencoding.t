use strict;
use warnings;

use Test::More;

use Test::Files;
use Test::File::Contents;

use File::chdir;

{
    local $CWD = 'vim-plugins/zencoding-vim';
    system 'make', 'bundle';
}

compare_dirs_ok 
    "$ENV{HOME}/.vim/bundle/zencoding-vim",
    'vim-plugins/zencoding-vim/zencoding-vim',
    "cd vim-plugins/zencoding-vim; make bundle; cp -r zencoding-vim ~/.vim/bundle/zencoding-vim";



done_testing();

