use strict;
use warnings;

use lib 't/lib';

use Test::More;
use MyTests;

is_pathogen_installed 'vim-fugitive';

done_testing;

