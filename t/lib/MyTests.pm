package MyTests;

use strict;
use warnings;

use Test::More;
use Test::Files qw/ compare_dirs_ok /;
use IPC::Run3;

use base 'Exporter';

our @EXPORT = qw/ is_pathogen_installed /;

sub is_pathogen_installed(@) {
    my $patho = $ENV{HOME}.'/.vim/bundle/'.$_[0];
    my $src = "vim-plugins/$_[0]";
    ok !system('diff', '-r', '--brief', $patho, $src ), $_[1]||$_[0]
        or diag "diff -r $patho $src";
}


1;
