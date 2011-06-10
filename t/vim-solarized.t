
use strict;
use warnings;

use Test::More tests => 1;                      # last test to print

use Test::Files qw/ compare_dirs_ok file_filter_ok /;


compare_dirs_ok 'vim-plugins/vim-colors-solarized', $ENV{HOME}.'/.vim/bundle/solarized'
    or diag "rm -fr $ENV{HOME}.'/.vim/bundle/solarized && cp -r vim-plugins/vim-colors-solarized ~/.vim/bundle/solarized";

my $vim_config = 'colorscheme solarized';

file_filter_ok 
    $ENV{HOME}.'/.vimrc',
    $vim_config,
    sub {
        return join '', grep { $_ eq $vim_config } split "\n", shift;
    },
    '~/.vimrc'
        or diag "echo '$vim_config' >> ~/.vimrc";



