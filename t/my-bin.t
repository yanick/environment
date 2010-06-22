use strict;
use warnings;

use Test::More;                      # last test to print
use Test::File::Contents;

my $bindir = $ENV{HOME} . '/bin';

for my $f ( grep { -f } <bin/*> ) {
    file_contents_identical( $ENV{HOME}.'/'.$f, $f, $f )
            or diag "cp $f $ENV{HOME}/bin";
}

done_testing;



