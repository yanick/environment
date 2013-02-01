#!/usr/bin/env perl

# usage: rt-to-github.pl <github_project> <rt-module>

use 5.10.0;

use strict;
use warnings;

use RT::Client::REST;
use RT::Client::REST::Ticket;

use Net::GitHub;

my $github_user       = 'yanick';
my $github_password   = '***';
my $github_repo_owner = 'yanick';
my $github_repo       = shift;

my $rt_user     = 'yanick';
my $rt_password = '***';
my $rt_dist     = shift || $github_repo;

my $gh = Net::GitHub->new(
    login => $github_user,
    pass  => $github_password,
);
$gh->set_default_user_repo( $github_user, $github_repo );

my $rt = RT::Client::REST->new( server => 'https://rt.cpan.org/' );
$rt->login(
    username => $rt_user,
    password => $rt_password
);

# see which tickets we already have on the github side
my @gh_issues =
  map { /\(rt(\d+)\)/ } 
  map { $_->{title} }    
      $gh->issue->issues(state => 'open');

say join ' ', 'github issues:', @gh_issues;

export_ticket( $_ ) for $rt->search(
    type  => 'ticket',
    query => qq{
        Queue = '$rt_dist' 
        and
        ( Status = 'new' or Status = 'open' )
    },
);

sub export_ticket {
    my $id = shift;

    say "ticket $id";

    return say "already on github" if $id ~~ @gh_issues;

    # get the information from RT
    my $ticket = RT::Client::REST::Ticket->new(
        rt => $rt,
        id => $id,
    );
    $ticket->retrieve;

    # we just want the first transaction, which
    # has the original ticket description
    my $desc = $ticket->transactions->get_iterator->()->content;

    # create the github ticket
    $gh->issue->create_issue( {
        title  => $ticket->subject . ' (rt' . $_ . ')',
        body   => "https://rt.cpan.org/Ticket/Display.html?id=$_\n\n" . $desc,
        labels => [ 'rt' ],
    } ) or warn "error in creating issue";
}
