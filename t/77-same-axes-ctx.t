use Test::More tests => 7;

use Chart::Clicker::Data::Series;
use Chart::Clicker::Data::Series::Size;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Renderer::Point;

BEGIN {
    use_ok('Chart::Clicker');
}

my $cc = Chart::Clicker->new;
isa_ok($cc, 'Chart::Clicker');

my $series = Chart::Clicker::Data::Series->new(
    keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
    values  => [ 42, 25, 86, 23, 2, 19, 103, 12, 54, 9 ],
);

my $series2 = Chart::Clicker::Data::Series->new(
    keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
    values  => [ 67, 15, 6, 90, 11, 45, 83, 11, 9, 101 ],
);

my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series ]);

my $sales = Chart::Clicker::Context->new(
    name => 'sales', domain_axis => $cc->get_context('default')->domain_axis
);
$cc->add_to_contexts($sales);

my $ds2 = Chart::Clicker::Data::DataSet->new(series => [ $series2 ]);
$ds2->context('sales');

$cc->add_to_datasets($ds, $ds2);

$cc->draw();

my $lrange = $cc->get_context('default')->range_axis;
my $bdomain = $cc->get_context('default')->domain_axis;

cmp_ok($lrange->position, 'eq', 'left', 'first range axis position');
cmp_ok($bdomain->position, 'eq', 'bottom', 'first domain axis position');

my $rrange = $cc->get_context('sales')->range_axis;
my $tdomain = $cc->get_context('sales')->domain_axis;

cmp_ok($rrange->position, 'eq', 'right', 'second range axis position');
cmp_ok($tdomain->position, 'eq', 'bottom', 'second domain axis position');

ok(defined($cc->data()), 'data');