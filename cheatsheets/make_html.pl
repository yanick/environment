#!/usr/bin/env perl 

use strict;
use warnings;

use Text::MultiMarkdown qw/ markdown /;
use Path::Tiny;

my $style = path('style.css')->slurp;

convert($_) for @ARGV;

sub convert {
    my $file = shift;

    my $html = markdown( path($file)->slurp );

    path($file =~ s/\..*?$/.html/r)->spew(<<"END");
<html>
<head>
<style>$style</style>
</head>
<body>
$html
</body>
</html>
END

}




