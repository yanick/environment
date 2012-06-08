
use strict;
use warnings;

use Test::More tests => 1;                      # last test to print

use Test::Files qw/ compare_dirs_ok file_filter_ok /;


compare_dirs_ok 'vim-plugins/vim-fugitive', $ENV{HOME}.'/.vim/bundle/fugitive'
    or diag "rm -fr $ENV{HOME}/.vim/bundle/fugitive && cp -r vim-plugins/vim-fugitive ~/.vim/bundle/fugitive";

