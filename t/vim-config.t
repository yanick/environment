
use strict;
use warnings;

use Test::More;
use Path::Class;

my $dest = $ENV{HOME}.'/.vimrc';
my $content = file($dest)->slurp;

my $src = dir('vim/config');

for ( grep { -f $_ and /\.vim$/ } $src->children ) {
    ok index( $content, scalar $_->slurp ) > -1, $_
        or diag "vimdiff $dest $_";
}

done_testing;



