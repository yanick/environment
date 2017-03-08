#!/usr/bin/env perl

use 5.20.0;

use Web::Query;
use Taskwarrior::Kusarigama::Wrapper;

my $lang = shift;

my $nbr_problems = wq('http://exercism.io/languages')
    ->find('p')
    ->filter(sub{ lc($_->text) eq lc $lang })
    ->next
    ->text +0 
        or die;

my $task = Taskwarrior::Kusarigama::Wrapper->new;

say $task->add( "$lang track +$lang", 
    { project => 'exercism', goal => $nbr_problems } 
);
