package MyUtils;

use strict;
use warnings;

use base qw/ Exporter /;

use Test::More;

use Test::Files;
use Test::File::Contents;
use File::Spec::Functions;

our @EXPORT = qw/ diff_file /;

sub diff_file($$) {
    my ( $src, $dest ) = @_;

    s/^~/$ENV{HOME}/ for $src, $dest;

    compare_ok( $src, $dest, $src )
        or diag "vimdiff $src $dest";
}

1;

