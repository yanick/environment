
use strict;
use warnings;

use Test::More;

use Test::File;
use Path::Class;
use File::HomeDir;

my $home = File::HomeDir->my_home;

my %files = (
    'vim/vimrc'   => "$home/.vimrc",
    'bash/bashrc' => "$home/.bashrc",
    'bash/bash_local' => "$home/.bash_local",
);

while( my ( $s, $d ) = each %files ) {
    symlink_target_is $d => file($s)->absolute;
}

done_testing;



