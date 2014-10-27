use strict;
use warnings;

use Test::More tests => 1;

use Path::Tiny;

sub is_softlink_to {
    my( $target, $src ) = map { path($_)->absolute } @_;

    is readlink($target) => $src, "$_[0] is a softlink for $_[1]";
}

is_softlink_to $ENV{HOME}.'/.config/peco' => './peco' or print <<'END';
diff --brief -r ~/.config/peco/config.json ./peco/config.json
rm -fr ~/.config/peco
ln -s `pwd`/peco ~/.config/peco
END



