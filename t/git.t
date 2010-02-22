use strict;
use warnings;

use Test::More;

use Test::Files;
use Test::File::Contents;
use File::Spec::Functions;

my $bindir = $ENV{HOME} . '/bin';

for my $script (
    qw/ git-publish-branch
    git-rank-contributors git-wt-add git-show-merges git-wtf /
  ) {
    compare_ok "$bindir/$script", "git/willgit/bin/$script",
      "cp git/willgit/bin/$script $bindir";
}

my $home = $ENV{HOME};

file_contents_identical( catfile( $home, 'bin', 'git-ignore' ),
    catfile( 'bin', 'git-ignore' ), 'git-ignore' );

done_testing();

