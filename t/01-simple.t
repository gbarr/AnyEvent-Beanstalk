#!perl

use Test::More;
use AnyEvent::Beanstalk;

do 't/start_server.pl';

our $port;

my $c = AnyEvent::Beanstalk->new(server => "127.0.0.1:$port");

plan tests => 10;

isa_ok($c, 'AnyEvent::Beanstalk');

{
  my @r = $c->use("foobar")->recv;
  is_deeply(\@r, ["foobar", "USING foobar"]);
}

{
  my @r = $c->watch("foobar")->recv;
  is_deeply(\@r, [2, "WATCHING 2"]);
}

{
  my @r = $c->list_tubes_watched->recv;
  is_deeply([sort @{$r[0] || []}], ["default","foobar"]);
}


$c->put(
  {data => "abc"},
  sub {
    my $job = shift;
    isa_ok($job, 'AnyEvent::Beanstalk::Job');
    is($job && $job->data, "abc");
  }
);

{
  my $job = $c->reserve->recv;
  isa_ok($job, 'AnyEvent::Beanstalk::Job');
  is($job && $job->data, "abc");
}

$c->stats(
  sub {
    my $stats = shift;
    isa_ok($stats, 'AnyEvent::Beanstalk::Stats');
    ok(eval { $stats->cmd_put });
  }
);

$c->sync;

done_testing;

