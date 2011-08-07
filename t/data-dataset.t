use Test::More;

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

is_deeply($dataset->get_series_values(0), [ 4, -1 ], 'get_series_values');

my @keys = $dataset->get_series_keys(2);
cmp_ok($keys[0], '==', 3, 'key 0');
cmp_ok($keys[1], '==', 4, 'key 1');
cmp_ok(scalar(@keys), '==', 2, '2 keys for position 2');

{
    my $ds2 = Chart::Clicker::Data::DataSet->new;
    my $s1 = Chart::Clicker::Data::Series->new(
        keys => [1, 3, 5],
        values => [1, 3, 5]
    );
    my $s2 = Chart::Clicker::Data::Series->new(
        keys => [1, 2, 5, 7],
        values => [2, 4, 8, 10]
    );
    $ds2->add_to_series($s1);
    $ds2->add_to_series($s2);

    is_deeply($ds2->get_series_values_for_key(1), [ 1, 2 ], 'get_series_values_for_key where both series have key');
    is_deeply($ds2->get_series_values_for_key(3), [ 3, undef ], 'get_series_values_for_key one series is missing key');
}

done_testing;