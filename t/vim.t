use strict;
use warnings;

use Test::More tests => 2;                      # last test to print

use Test::File::Contents;
use Test::Files;
use File::Spec::Functions;

my $home = $ENV{HOME};

file_contents_identical( catfile( $home, '.vimrc' ), catfile( 'vim', 'vimrc'
    ), '.vimrc' );

file_contents_identical( 
    "$home/.vim/after/plugin/snipMate.vim",
    "vim/vim/after/plugin/snipMate.vim",
    '.vim/after/plugin/snipMate.vim'
);
