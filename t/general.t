# tests to verify that the environment is applied

use strict;
use warnings;

use Test::More; 

use Test::Files;
use Test::File::Contents;

file_contents_identical $ENV{HOME} . '/bin/perldoc-complete',
  'perldoc-complete/perldoc-complete',
  'perldoc-complete' 
      or diag "cp perldoc-complete/perldoc-complete $ENV{HOME}/bin";

compare_ok $ENV{HOME} . '/.bash/mine.bash', 'bash/mine.bash', 
    'cp bash/mine.bash ~/.bash/mine.bash';

file_contents_like $ENV{HOME}.'/.bashrc', 
    qr#^\s*source \$HOME/\.bash/mine\.bash#m,
    q{echo 'source $HOME/.bash/mine.bash' > ~/.bashrc};

compare_ok $ENV{HOME} . '/.bash/aliases', 'bash/aliases',
    'aliases';


done_testing();

