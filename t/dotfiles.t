use strict;
use warnings;

use Test::More;

use Test::File;
use Path::Class;
use File::HomeDir;

my $home = File::HomeDir->my_home;

my %files = (
    'dotfiles/proverc'   => "$home/.proverc",
);

while( my ( $s, $d ) = each %files ) {
    symlink_target_is $d => file($s)->absolute;
}

done_testing;



