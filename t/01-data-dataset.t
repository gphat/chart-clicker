use Test::More tests => 14;

BEGIN { use_ok('Chart::Clicker::Data::DataSet'); }
BEGIN { use_ok('Chart::Clicker::Data::Series'); }

my $dataset = new Chart::Clicker::Data::DataSet();
ok(defined($dataset), 'new Chart::Clicker::Data::DataSet');
isa_ok($dataset, 'Chart::Clicker::Data::DataSet', 'isa Chart::Data::DataSet');

my $series = new Chart::Clicker::Data::Series();
my $name = 'Foo';
$series->name($name);
$series->keys([1, 2, 3]);
$series->values([4, 5, 6]);

eval { $dataset->prepare() };
ok($@, 'Fail on empty dataset');

my $series2 = new Chart::Clicker::Data::Series();
$series2->keys([1, 2]);
$series2->values([-1, 102]);

$dataset->series([ $series, $series2 ]);
$dataset->prepare();
my $ds = $dataset->series();
ok(defined($ds), 'Series set');
ok(defined($ds->[0]), '0th Series set');
ok(defined($ds->[0]->name() eq $name), 'Name set on series');
ok($dataset->count() == 2, 'Series count');
ok($dataset->max_key_count() == 3, 'Max Keys');
ok($dataset->range->lower() == -1, 'Min Range');
ok($dataset->range->upper() == 102, 'Max Range');
ok($dataset->domain->lower() == 1, 'Min Domain');
ok($dataset->domain->upper() == 3, 'Max Domain');
