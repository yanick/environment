
use strict;
use warnings;

use Test::More;

use Test::File::Contents; 
use File::HomeDir;

my $home = File::HomeDir->my_home;

my %files = (
    'vim/vimrc' => "$home/.vimrc",
);

while( my ( $s, $d ) = each %files ) {
    files_eq $d => $s, $s;
}

done_testing;



