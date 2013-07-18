use strict;
use warnings;

use Test::More tests => 1;

use Test::Files;
use File::HomeDir;


compare_dirs_ok( 
    File::HomeDir->my_home . '/.weechat' => 'weechat', 'weechat config dir' 
);



