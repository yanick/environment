
use strict;
use warnings;

use Test::More tests => 1;                      # last test to print

use Test::Files;

use File::chdir;

{
    local $CWD = 'vim-plugins/vim-perl';
    system 'make', 'local';
}

compare_dirs_ok 
    "$ENV{HOME}/.vim/bundle/vim-perl",
    'vim-plugins/vim-perl/vim-perl',
    "cd vim-plugins/vim-perl; make install-pathogen";


