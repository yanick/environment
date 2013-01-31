#!/usr/bin/perl 

use 5.16.0;

use strict;
use warnings;

use Path::Iterator::Rule;
use Path::Tiny;
use List::AllUtils qw/ indexes before apply first /;
use Git::Repository;
use IO::Prompt::Tiny qw/prompt/;
use Net::GitHub;

my $git = Git::Repository->new( work_tree => '.' );

my( $project ) = first { /^github/ } $git->run( 'remote', '-v' );
$project =~ s/^.*?://;
$project =~ s/\.git.*$//;

my $github = Net::GitHub->new(
    login => 'yanick', 
    pass => '***',
);

$github->set_default_user_repo( split '/', $project );

Path::Iterator::Rule->new
    ->file
    ->name( qr/\.p[lm]$/ )
    ->and( sub{ 
        my $path = path($_);

        my @lines = $path->lines;
        process_todo( $path, $_, \@lines ) for indexes { 
            /^ \s* \# \s* (?:TODO|FIXME) /x and not /\[GH\d+\]/ 
        } @lines;

        return 0; # we don't want to collect the files
    })
    ->all( @ARGV );

sub process_todo {
    my( $file, $nbr ) = @_;
    my @lines = @{$_[2]};

    my $subject = $lines[$nbr] =~ s/^.*?#\s*(?:TODO|FIXME)\s*//r;
    my @body = apply { s/^\s*#\s?// } before { !/^\s*#/ }  @lines[$nbr+1..$#lines];

    # TODO don't assume master
    my $url = "https://github.com/$project/blob/master/$file#L$nbr";
    $url .= '-' . ($nbr+@body) if @body;

    say $subject;
    say "";
    say @body;

    prompt( "create Issue? (y/N)", 'n' ) =~ /y/ or return;

    my $isu = $github->issue->create_issue( {
        "title" => $subject,
        "body" => join( '', @body, "\n\n", $url ),
        labels => [ 'code todo' ],
    } ) or die "error in creating issue";

    say "issue ", $isu->{number}, " created";
    say $isu->{html_url};
    say "";

    my $issue = $isu->{number};

    $lines[$nbr] =~ s/(TODO|FIXME)/$1 [GH$issue]/;

    $file->spew(@lines);
}





