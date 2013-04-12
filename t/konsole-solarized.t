use strict;
use warnings;

use Test::More;

use Test::File::Contents qw/ files_eq /;
use Path::Tiny;
use File::HomeDir;

my $src_dir = path( 'konsole-colors-solarized' );
my( $target_dir ) = grep { -d $_ } 
    map { $_->child('.kde4'), $_->child('.kde') } path( File::HomeDir->my_home );

for my $file ( grep { /\.colorscheme$/ } $src_dir->children ) {
    files_eq "$file" => ''.path( $target_dir )->child(
        path($file)->basename ), $file;
}

done_testing;


