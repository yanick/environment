# tests to verify that the environment is applied

use strict;
use warnings;

use Test::More; 

use Test::Files;
use Test::File::Contents;

compare_ok $ENV{HOME} . '/bin/perldoc-complete',
  'perldoc-complete/perldoc-complete',
  'perldoc-complete';

compare_ok $ENV{HOME} . '/.bash/mine.bash', 'bash/mine.bash', 
    'cp bash/mine.bash ~/.bash/mine.bash';

file_contents_like $ENV{HOME}.'/.bashrc', 
    qr#^\s*source \$HOME/\.bash/mine\.bash#m,
    q{echo 'source $HOME/.bash/mine.bash' > ~/.bashrc};


done_testing();

