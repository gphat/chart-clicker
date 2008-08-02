use Test::More tests => 24;

BEGIN { use_ok('Chart::Clicker::Data::DataSet'); }
BEGIN { use_ok('Chart::Clicker::Data::Series'); }

my $dataset = Chart::Clicker::Data::DataSet->new;
cmp_ok($dataset->context, 'eq', 'default', 'context');
ok(defined($dataset), 'new Chart::Clicker::Data::DataSet');
isa_ok($dataset, 'Chart::Clicker::Data::DataSet', 'isa Chart::Data::DataSet');

my $series = Chart::Clicker::Data::Series->new;
my $name = 'Foo';
$series->name($name);
$series->keys([1, 2, 3]);
$series->values([4, 5, 6]);

eval { $dataset->prepare };
ok($@, 'Fail on empty dataset');

my $series2 = Chart::Clicker::Data::Series->new;
$series2->name('Second');
$series2->keys([1, 2, 4]);
$series2->values([-1, 102, 12]);

$dataset->add_to_series($series);
cmp_ok($dataset->count, '==', 1, 'count is correct');
$dataset->add_to_series($series2);
cmp_ok($dataset->count, '==', 2, 'count is correct');

$dataset->prepare;

cmp_ok($dataset->largest_value_slice, '==', 107, 'largest_value_slice');

my $ds = $dataset->series;
ok(defined($ds), 'Series set');
ok(defined($ds->[0]), '0th Series set');
ok(defined($ds->[0]->name eq $name), 'Name set on series');
cmp_ok($dataset->count, '==', 2, 'Series count');
cmp_ok($dataset->max_key_count, '==', 3, 'Max Keys');
cmp_ok($dataset->range->lower, '==', -1, 'Min Range');
cmp_ok($dataset->range->upper, '==', 102, 'Max Range');
cmp_ok($dataset->domain->lower, '==', 1, 'Min Domain');
cmp_ok($dataset->domain->upper, '==', 4, 'Max Domain');

my @values = $dataset->get_series_values(0);
cmp_ok(scalar(@values), '==', 2, '2 values for position 0');
cmp_ok($values[0], '==', 4, 'value 0');
cmp_ok($values[1], '==', -1, 'value 1');

my @keys = $dataset->get_series_keys(2);
cmp_ok($keys[0], '==', 3, 'key 0');
cmp_ok($keys[1], '==', 4, 'key 1');
cmp_ok(scalar(@keys), '==', 2, '2 keys for position 2');
