#!perl

use AnyEvent::Beanstalk;
use Test::More;

do 't/start_server.pl';

our $port;

my $c = AnyEvent::Beanstalk->new(server => "127.0.0.1:$port");

plan tests => 2;

$c->use('foo')->recv;
$c->watch('bar')->recv;
$c->reconnect();
is($c->using(), 'foo');
ok(grep { $_ eq 'bar' } $c->watching());

done_testing;



