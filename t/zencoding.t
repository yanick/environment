use strict;
use warnings;

use Test::More;

use Test::Files;
use Test::File::Contents;

compare_ok "$ENV{HOME}/.vim/plugin/zencoding.vim" => 'zencoding-vim/zencoding.vim'
    or diag "cp zencoding-vim/zencoding.vim $ENV{HOME}/.vim/plugin";

use Test::Files;

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

