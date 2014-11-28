use strict;
use warnings;

use Test::More;

use Test::File;
use Path::Tiny;
use File::HomeDir;

my $home = File::HomeDir->my_home;

my %files = (
    'fonts/fonts.conf'   => "$home/.fonts.conf",
    'fonts/fontconfig'   => "$home/.config/fontconfig",
);

while( my ( $s, $d ) = each %files ) {
    symlink_target_is $d => path($s)->absolute;
}

done_testing;



