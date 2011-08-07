use Test::More;

BEGIN {
    use_ok('Chart::Clicker::Axis::DateTime');
}

my $a = Chart::Clicker::Axis::DateTime->new(
    position => 'left',format => '%H:%M:%S', orientation => 'vertical'
);
isa_ok($a, 'Chart::Clicker::Axis::DateTime');
my $foo = $a->format_value(time);
ok($foo =~ /\d+:\d+:\d/, 'Formatted Properly');

my $dt = DateTime->new(
    'year'  => 2007,
    'month' => 8,
    'day'   => 30,
    'hour'  => 18,
    'minute'=> 53,
    'second'=> 00,
    'time_zone' => 'America/Chicago'
);

$a->time_zone('UTC');
my $formatted = $a->format_value($dt->epoch);
cmp_ok($formatted, 'eq', '23:53:00', 'Proper formatting with timezone');

done_testing;