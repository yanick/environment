
use strict;
use warnings;

use Test::More;                      # last test to print

use Test::Files;
use File::Find;

diag <<END;
    to install

    perl -MExtUtils::Install -e'install({ "vim/plugins/snipMate" => "$ENV{HOME}/.vim" })'
END


find( \&wanted, 'vim/plugins/snipMate' );

sub wanted {
    return unless -f $_;
    my $file = $File::Find::name;
    $file =~ s#^.*snipMate/##;
    compare_ok $ENV{HOME}.'/.vim/'.$file, $_, $File::Find::name;

}


done_testing;

