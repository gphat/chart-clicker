use Test::More tests => 8;

BEGIN { use_ok('Chart::Clicker::Data::Series::HighLow'); }

my $series = Chart::Clicker::Data::Series::HighLow->new;
ok(defined($series), 'new Chart::Clicker::Data::Series::HighLow');
isa_ok($series, 'Chart::Clicker::Data::Series::HighLow');

my $fooseries = Chart::Clicker::Data::Series::HighLow->new({
    keys => [ 1, 2, 3, 4 ],
    highs => [ 11, 9, 12, 14 ],
    lows => [ 5, 1, 4, 12 ],
    opens => [ 4, 5, 6, 7 ],
    values => [ 5, 6, 7, 14 ],
});

cmp_ok($fooseries->get_high(1), '==', 9, 'high 1');
cmp_ok($fooseries->get_low(1), '==', 1, 'low 1');
cmp_ok($fooseries->get_open(1), '==', 5, 'open 5');

my $range = $fooseries->range;
cmp_ok($range->lower, '==', 1, 'range lower');
cmp_ok($range->upper, '==', 14, 'range upper');