use Test::More tests => 19;

BEGIN { use_ok('Chart::Clicker::Data::Range'); }

my $range = Chart::Clicker::Data::Range->new({ lower => 0, upper => 10 });
ok(defined($range), 'new Chart::Clicker::Data::Range');
isa_ok($range, 'Chart::Clicker::Data::Range', 'isa Chart::Clicker::Data::Range');
cmp_ok($range->lower, '==', 0, 'Lower');
cmp_ok($range->upper, '==', 10, 'Upper');

my $divvy = $range->divvy(5);
cmp_ok(scalar(@{ $divvy }), '==', 5, 'divvy count');
is_deeply($divvy, [ 0, 2.5, 5, 7.5, 10 ], 'divvy results');
cmp_ok($range->span, '==', 10, 'span');

$range->combine(Chart::Clicker::Data::Range->new({ lower => 3, upper => 15 }));
cmp_ok($range->lower, '==', 0, 'Combine 1: Lower stays');
cmp_ok($range->upper, '==', 15, 'Combine 1: Upper moves');

$range->combine(Chart::Clicker::Data::Range->new({ lower => -1, upper => 5 }));
cmp_ok($range->lower, '==', -1, 'Combine 2: Lower moves');
cmp_ok($range->upper, '==', 15, 'Combine 2: Upper stays');

my $range2 = Chart::Clicker::Data::Range->new({ lower => 1, upper => 10 });
my $max = 11;
$range2->max($max);
cmp_ok($range2->upper, '==', $max, 'Upper == max');

my $min = 3;
$range2->min($min);
cmp_ok($range2->lower, '==', $min, 'Lower == min');

cmp_ok($range2->span, '==', ($max - $min), 'Span == (max - min)');

$range2->combine(Chart::Clicker::Data::Range->new({ lower => -1, upper => 50 }));
cmp_ok($range2->upper, '==', $max, 'Upper == max after combine');
cmp_ok($range2->lower, '==', $min, 'Lower == min after combine');

my $range3 = Chart::Clicker::Data::Range->new;
$range3->combine(Chart::Clicker::Data::Range->new({ lower => 3, upper => 15 }));
cmp_ok($range3->lower, '==', 3, 'Undefined range, combine check lower');
cmp_ok($range3->upper, '==', 15, 'Undefined range, combine check upper');
