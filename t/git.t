use strict;
use warnings;

use Test::More;

use Test::Files;
use Test::File::Contents;
use File::Spec::Functions;

use lib 't/lib';
use MyUtils;

my $bindir = $ENV{HOME} . '/bin';

diff_file "git/gitconfig" => "~/.gitconfig";

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

for ( map { "git-$_" } qw/ ghclone ghnetwork / ) {
file_contents_identical( catfile( $home, 'bin', $_ ),
    catfile( 'git', 'commands', $_ ), $_,
    ) or diag "cp git/commands/$_ ~/bin/";
}

done_testing();
