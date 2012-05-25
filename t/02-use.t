#!perl

use Test::More;
use AnyEvent::Beanstalk;

do 't/start_server.pl';

our $port;

my $c = AnyEvent::Beanstalk->new(server => "127.0.0.1:$port");

plan tests => 1;

$c->use('foo')->recv();
is($c->using(), 'foo');

done_testing;

