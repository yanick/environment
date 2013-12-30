use strict;
use warnings;

use Test::More tests => 1;

use Path::Tiny;

sub is_softlink_to {
    my( $target, $src ) = map { path($_)->absolute } @_;

    is readlink($target) => $src, "$_[0] is a softlink for $_[1]";
}

is_softlink_to $ENV{HOME}.'/.perldb' => './perl/perldb' or print <<'END';
diff --brief -r ~/.perldb ./perl/perldb
rm -fr ~/.perldb
ln -s `pwd`/perl/perldb ~/.perldb
END



