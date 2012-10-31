# tests to verify that the environment is applied

use strict;
use warnings;

use Test::More; 

use Test::Files;
use Test::File::Contents;


compare_ok $ENV{HOME} . '/.bash/mine.bash', 'bash/mine.bash', 
    'cp bash/mine.bash ~/.bash/mine.bash';

file_contents_like $ENV{HOME}.'/.bashrc', 
    qr#^\s*source \$HOME/\.bash/mine\.bash#m,
    q{echo 'source $HOME/.bash/mine.bash' > ~/.bashrc};

compare_ok $ENV{HOME} . '/.bash/aliases', 'bash/aliases',
    'aliases'
        or diag "gvimdiff bash/aliases $ENV{HOME}/.bash/aliases";


done_testing();

