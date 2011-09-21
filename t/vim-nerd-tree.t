use strict;
use warnings;

use Test::Files;
use Test::More;
use Path::Class;

my $dest = dir( $ENV{HOME}, qw/ .vim bundle nerd-tree / );
my $src = dir( qw/ . vim-plugins nerd-tree / );

compare_dirs_ok( $dest => $src )
    or diag "cp -r $src $dest";

done_testing;

