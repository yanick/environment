use strict;
use warnings;

use Test::More; 

use Test::Files;
use Test::File::Contents;
use File::Slurp qw/ slurp /;

chdir 'bash';

for my $bit ( <bits/*.bash> ) {
    file_contents_identical( $ENV{HOME}.'/.bash/'.$bit, $bit, $bit )
        or diag "cp bash/$bit $ENV{HOME}/.bash/bits";
}

done_testing;
