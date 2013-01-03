#!/usr/bin/env perl 
 
use 5.16.0;
 
use strict;
 
local $/;
 
my $snippet = <>;
 
$snippet =~ s/^\s*\n//gm;
my ($indent) = $snippet =~ /^(\s*)/;
$snippet =~ s/^$indent//gm;
 
my $operators = join '|', qw/ if unless while for until /;
 
my $block_re = qr/
    ^
    (?<operator>$operators)
        \s* (?:my \s+ (?<variable>\$\w+) \s* )?
        \( \s* (?<array>[^)]+) \) \s* {
            (?<inner>.*)  
        }
        \s* $
/xs;
 
my $postfix_re = qr/
    ^
    (?<inner>[^;]+?) 
    \s+ (?<operator>$operators) 
    \s+ (?<array>[^;]+?) 
    \s* ;
    $
/xs;
 
if ( $snippet =~ $block_re ) {
    $snippet = block_to_postifx( $snippet, %+ );
}
elsif( $snippet =~ $postfix_re ) {
    $snippet = postfix_to_block( $snippet, %+ );
}
 
$snippet =~ s/^/$indent/gm;
 
say $snippet;
 
sub postfix_to_block {
    my( $snippet, %capture ) = @_;
 
    $snippet = $capture{inner};
    chomp $capture{array};
    $snippet = "$capture{operator} ( $capture{array} ) {\n    $snippet;\n}";
 
}
 
sub block_to_postifx {
    my( $snippet, %capture ) = @_;
 
    # more than one statement? Don't touch it
    return $snippet if $capture{inner} =~ /(;)/ > 1;
 
    $snippet = $capture{inner};
    $snippet =~ s/;\s*$//; 
 
    $snippet =~ s/\Q$capture{variable}/\$_/g;
    $snippet =~ s/\$_\s*=~\s*//g;
 
    $capture{array} =~ s/\s*$//;
 
    $snippet .= " $capture{operator} $capture{array};";
 
    return $snippet;
}
