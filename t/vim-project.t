#
#===============================================================================
#
#         FILE:  vim-project.t
#
#  DESCRIPTION:  
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Yanick Champoux (YANICK), <yanick@cpan.org>
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  06/28/2010 12:39:59 PM EDT
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Test::Files;
use Test::More;

my @files = qw(
    doc/project.txt
    plugin/project.vim
);

for ( @files ) {
    compare_ok( $ENV{HOME} . '/.vim/' . $_, 'vim-plugins/project/' . $_ )
        or diag "cp vim-plugins/project/$_ $ENV{HOME}/.vim/$_";
};

done_testing;

