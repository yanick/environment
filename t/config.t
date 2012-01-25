use strict;
use warnings;

use Test::More;

use Test::Files;
use Test::File::Contents;
use File::HomeDir;
use Path::Class qw/ file /;

for ( qw# perlcriticrc  perltidyrc # ) {
    my $local = file( home(), '.'.$_ );
    my $template = file( 'config', $_ );
    file_contents_identical $local => $template, $_
        or diag "vimdiff $local $template";
}




done_testing;
