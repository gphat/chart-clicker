use Test::More tests => 14;

BEGIN { use_ok('Chart::Clicker::Data::Range'); }

my $range = new Chart::Clicker::Data::Range({ lower => 1, upper => 10 });
ok(defined($range), 'new Chart::Clicker::Data::Range');
isa_ok($range, 'Chart::Clicker::Data::Range', 'isa Chart::Clicker::Data::Range');

$range->combine(new Chart::Clicker::Data::Range({ lower => 3, upper => 15 }));
ok($range->lower() == 1, 'Combine 1: Lower stays');
ok($range->upper() == 15, 'Combine 1: Upper moves');

$range->combine(new Chart::Clicker::Data::Range({ lower => -1, upper => 5 }));
ok($range->lower() == -1, 'Combine 2: Lower moves');
ok($range->upper() == 15, 'Combine 2: Upper stays');

my $range2 = new Chart::Clicker::Data::Range({ lower => 1, upper => 10 });
my $max = 11;
$range2->max($max);
ok($range2->upper() == $max, 'Upper == max');

my $min = 3;
$range2->min($min);
ok($range2->lower() == $min, 'Lower == min');

ok($range2->span() == ($max - $min), 'Span == (max - min)');

$range2->combine(new Chart::Clicker::Data::Range({ lower => -1, upper => 50 }));
ok($range2->upper() == $max, 'Upper == max after combine()');
ok($range2->lower() == $min, 'Lower == min after combine()');

my $range3 = new Chart::Clicker::Data::Range();
$range3->combine(new Chart::Clicker::Data::Range({ lower => 3, upper => 15 }));
ok($range3->lower() == 3, 'Undefined range, combine check lower');
ok($range3->upper() == 15, 'Undefined range, combine check upper');
