
our $exe  = $ENV{BEANSTALKD_EXE};
our $port = $ENV{BEANSTALKD_PORT} || 11300;

unless ($exe) {
  ($exe) = grep { -x $_ } qw(/opt/local/bin/beanstalkd /usr/local/bin/beanstalkd /usr/bin/beanstalkd);
}

unless ($exe && -x $exe) {
  plan(skip_all => 'Set environment variable BEANSTALKD_EXE & BEANSTALKD_PORT to run live tests');
}

$SIG{CHLD} = 'IGNORE';
if (my $pid = fork()) {
  END { kill 9, $pid if $pid }
  sleep(2);
  plan(skip_all => "Cannot start server: $!")
    unless kill 0, $pid;
}
elsif (defined $pid) {
  exec($exe, '-p', $port);
  die("Cannot exec $exe: $!\n");
}
else {
  plan(skip_all => "Cannot fork: $!");
}

