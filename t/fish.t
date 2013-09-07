use strict;
use warnings;

use Test::More tests => 1;

use Path::Tiny;

sub is_softlink_to {
    my( $target, $src ) = map { path($_)->absolute } @_;

    is readlink($target) => $src, "$_[0] is a softlink for $_[1]";
}

is_softlink_to $ENV{HOME}.'/.config/fish' => './fish' or print <<'END';
diff --brief -r ~/.config/fish ./fish
rm -fr ~/.config/fish
ln -s `pwd`/fish ~/.config/fish
END



