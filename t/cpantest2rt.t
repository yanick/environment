use strict;
use warnings;

use Test::More;                      # last test to print
use Test::File::Contents;
use File::chdir;

my $f = "$CWD/cpantest2rt/cpantest2rt.pl";

file_contents_identical( $ENV{HOME}.'/'.'cpantest2rt.pl', $f, $f )
            or diag "cp $f $ENV{HOME}/bin";

done_testing;



