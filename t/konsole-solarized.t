use strict;
use warnings;

use Test::More;

use Test::File::Contents qw/ files_eq /;
use Path::Tiny;
use File::HomeDir;

my $src_dir = path( 'konsole-colors-solarized' );
my( $target_dir ) = grep { -d $_ } 
    map { $_->child('.kde4'), $_->child('.kde') } path( File::HomeDir->my_home );

$target_dir = path($target_dir)->child( 'share/apps/konsole' );

my $all_good = 1;

for my $file ( grep { /\.colorscheme$/ } $src_dir->children ) {
    $all_good &&= files_eq "$file" => ''.$target_dir->child(
        path($file)->basename ), $file;
}

diag "cp $src_dir/*.colorscheme $target_dir" unless $all_good;

done_testing;


