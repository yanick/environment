use strict;
use warnings;

use Test::More tests => 1;                      # last test to print
use Test::Files;
use Test::File::Contents;

compare_ok $ENV{HOME}.'/bin/mempeek', 'mempeek/mempeek.pl', '~/bin/mempeek';


