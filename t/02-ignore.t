#!perl

use Test::More;
use AnyEvent::Beanstalk;

do 't/start_server.pl';

our $port;

my $c = AnyEvent::Beanstalk->new(server => "127.0.0.1:$port");

plan tests => 2;

$c->watch('foo')->recv();
ok(grep { $_ eq 'foo' } $c->watching());

$c->ignore('default')->recv();
ok(!grep { $_ eq 'default' } $c->watching());

done_testing;


