use strict;
use warnings;

use Test::More; 

use Test::Files;
use Test::File::Contents;

my $bindir = $ENV{HOME}.'/bin';

for my $script ( qw/ git-publish-branch 
    git-rank-contributors git-wt-add git-show-merges git-wtf / ) {
    compare_ok "$bindir/$script", "git/willgit/bin/$script", "cp git/willgit/bin/$script $bindir";
}

done_testing();



