
use strict;
use warnings;

use File::HomeDir;
use Path::Class;

use Test::More tests => 2;                      # last test to print

use Test::File::Contents;

my $vim_txt = 'call pathogen#runtime_append_all_bundles()';

my $vimrc = file( File::HomeDir->my_home, '.vimrc' );

file_contents_like $vimrc,  qr/\Q$vim_txt/, '.vimrc config' or diag "echo '$vim_txt' > $vimrc";

my $src  = file( qw/ vim-plugins vim-pathogen autoload pathogen.vim / );
my $dest = file( File::HomeDir->my_home, '.vim', 'autoload', 'pathogen.vim' );
my $solution = "cp $src $dest";

file_contents_identical $src => $dest or diag $solution;


