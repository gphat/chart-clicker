use Test::More tests => 17;

BEGIN {
    use_ok('Cairo');
    use_ok('Chart::Clicker');
    use_ok('Chart::Clicker::Axis');
    use_ok('Chart::Clicker::Data::DataSet');
    use_ok('Chart::Clicker::Data::Series');
    use_ok('Chart::Clicker::Decoration::Grid');
    use_ok('Chart::Clicker::Decoration::Label');
    use_ok('Chart::Clicker::Decoration::Legend');
    use_ok('Chart::Clicker::Renderer::Area');
}

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

my $tlabel = Chart::Clicker::Decoration::Label->new({ text => 'Danes', orientation => 'horizontal' });
my $tlabel2 = Chart::Clicker::Decoration::Label->new({ text => 'Footballs', orientation => 'vertical' });
my $tlabel3 = Chart::Clicker::Decoration::Label->new({ text => 'Boots', orientation => 'vertical' });
my $tlabel4 = Chart::Clicker::Decoration::Label->new({ text => 'Goals', orientation => 'horizontal' });
$chart->add_component($tlabel, 'north');
$chart->add_component($tlabel2, 'west');
$chart->add_component($tlabel3, 'east');
$chart->add_component($tlabel4, 'south');

cmp_ok($chart->component_count(), '==', 4, 'component_count');

my $plot = $chart->plot();
$plot->add_to_renderers(Chart::Clicker::Renderer::Area->new());

$chart->prepare();
$chart->do_layout($chart);

cmp_ok($tlabel->origin->x, '==', (0 + $tlabel2->width), 'label origin x');
cmp_ok($tlabel->origin->y, '==', 0, 'label origin y');
cmp_ok($tlabel->width, '==', 300 - $tlabel2->width - $tlabel3->width, 'label width');

cmp_ok($tlabel2->origin->x, '==', 0, 'label origin x');
cmp_ok($tlabel2->origin->y, '==', 0 + $tlabel->height, 'label origin y');

$chart->draw();
$chart->write('/Users/gphat/foo.png');

