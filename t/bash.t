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

file_contents_identical( $ENV{HOME}.'/.bash/aliases', 'aliases', 'aliases' )
    or diag "vimdiff bash/aliases ~/.bash";

file_contents_identical( $ENV{HOME}.'/.bashrc', 'bashrc', 'bashrc' )
    or diag "vimdiff bash/bashrc ~/.bashrc";

file_contents_identical( $ENV{HOME}.'/.bash_profile', 'bash_profile',
    'bash_profile' )
    or diag "vimdiff bash/bash_profile ~/.bash_profile";

done_testing;
