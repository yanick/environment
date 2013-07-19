use strict;
use warnings;

use Test::More tests => 1; 

use Test::Files;
use File::HomeDir;

my $home = File::HomeDir->my_home;

compare_ok(
    "$home/.xinitrc" => "./xresources/xinitrc", 'xinitrc'
);


