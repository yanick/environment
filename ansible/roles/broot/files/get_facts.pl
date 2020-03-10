#!/usr/bin/env perl

use strict;
no warnings;

use YAML;

my $program = 'broot';

my %facts;

chomp( $facts{location} = `which $program` );

if( $facts{location} ) {
    ($facts{version}) = `$program --version` =~ /broot (.*)/;
    $facts{num_version} = $facts{num_version} * 1_000 + $_
        for split /\./, ($facts{version} =~ /(\d+\.\d+(?:\.\d+)?)/g)[0];
}

$facts{num_version} ||= 0;

print YAML::Dump( \%facts );


