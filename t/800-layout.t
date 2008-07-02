use Test::More tests => 14;

BEGIN {
    use_ok('Cairo');
    use_ok('Chart::Clicker');
    use_ok('Chart::Clicker::Axis');
    use_ok('Chart::Clicker::Data::DataSet');
    use_ok('Chart::Clicker::Data::Series');
    use_ok('Chart::Clicker::Decoration::Grid');
    use_ok('Chart::Clicker::Decoration::Label');
    use_ok('Chart::Clicker::Decoration::Legend');
    use_ok('Chart::Clicker::Drawing');
    use_ok('Chart::Clicker::Renderer::Area');
}

use Chart::Clicker::Drawing qw(:positions);

my $chart = Chart::Clicker->new({ width => 300, height => 250 });
ok(defined($chart), 'new Chart::Clicker');

my $series = Chart::Clicker::Data::Series->new();
my @keys = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
my @vals = (42, 25, 86, 23, 2, 19, 103, 12, 54, 9);
$series->keys(\@keys);
$series->values(\@vals);

my $series2 = Chart::Clicker::Data::Series->new();
my @keys2 = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
my @vals2 = (67, 15, 6, 90, 11, 45, 83, 11, 9, 101);
$series2->keys(\@keys2);
$series2->values(\@vals2);

my $dataset = Chart::Clicker::Data::DataSet->new();
$dataset->series([ $series, $series2 ]);

$chart->datasets([ $dataset ]);

my $tlabel = Chart::Clicker::Decoration::Label->new({ text => 'Danes', orientation => $CC_HORIZONTAL});
$chart->add_component($tlabel, 'north');

my $plot = $chart->plot();
$plot->add_to_renderers(Chart::Clicker::Renderer::Area->new());

$chart->prepare();
$chart->do_layout($chart);
# 
# cmp_ok($tlabel->location->x(), '==', ($chart->insets->left() + 1), 'Label X position');
# cmp_ok($tlabel->location->y(), '==', ($chart->insets->top() + 1), 'Label Y position');
