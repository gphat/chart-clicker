use Test::More;

BEGIN { use_ok('Chart::Clicker::Data::Series::Size'); }

my $series = Chart::Clicker::Data::Series::Size->new();
ok(defined($series), 'new Chart::Clicker::Data::Series::Size');
isa_ok($series, 'Chart::Clicker::Data::Series::Size');

my @values = (1, 2, 10);
my @keys = (1, 2, 3);
my @sizes = (3, 6);

$series->values(\@values);
$series->keys(\@keys);
$series->sizes(\@sizes);

cmp_ok($series->size_count, '==', 2, '2 sizes');

$series->add_to_sizes(5);
cmp_ok($series->size_count, '==', 3, '3 sizes');

cmp_ok($series->max_size, '==', 6, 'get_max_size');
cmp_ok($series->min_size, '==', 3, 'get_min_size');

done_testing;