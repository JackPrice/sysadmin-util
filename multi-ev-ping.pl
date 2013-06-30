#!/usr/bin/perl

use AnyEvent;
use AnyEvent::Ping;

my $cocurrent = 100;
my $todolist = ("www.baidu.com", "www.google.com");

my $cv = AnyEvent->condvar;

my $ping = AnyEvent::Ping->new;

doit() foreach 1 .. $cocurrent;

sub doit {
    my $ip = shift @todolist;
    return if not defined $ip;
    
    $cv->begin;
    $ping->ping($ip, 1, sub { done( $ip, @_ ) } );
}

sub done {
    my ($ip, $result) = @_;
    
    $cv->end();
    print "Result($ip): ", $result->[0][0], " in ", $result->[0][1], " seconds\n";
    doit();
}

$cv->recv();
