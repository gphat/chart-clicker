use Test::More tests => 19;

BEGIN {
    use_ok('Chart::Clicker');
    use_ok('Chart::Clicker::Axis');
    use_ok('Chart::Clicker::Data::DataSet');
    use_ok('Chart::Clicker::Data::Series');
    use_ok('Chart::Clicker::Decoration::Grid');
    use_ok('Chart::Clicker::Decoration::Label');
    use_ok('Chart::Clicker::Decoration::Legend');
    use_ok('Chart::Clicker::Decoration::Plot');
    use_ok('Chart::Clicker::Drawing');
    use_ok('Chart::Clicker::Drawing::Container');
    use_ok('Chart::Clicker::Renderer::Area');
    use_ok('Chart::Clicker::Renderer::Bar');
    use_ok('Chart::Clicker::Renderer::Line');
    use_ok('Chart::Clicker::Renderer::Point');
}

use Chart::Clicker::Drawing qw(:positions);

my $chart = new Chart::Clicker({ width => 300, height => 250 });
ok(defined($chart), 'new Chart::Clicker');

my $series = new Chart::Clicker::Data::Series();
my @keys = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
my @vals = (42, 25, 86, 23, 2, 19, 10, 12, 40, 9);
$series->keys(\@keys);
$series->values(\@vals);

my $series2 = new Chart::Clicker::Data::Series();
my @keys2 = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
my @vals2 = (67, 15, 6, 90, 11, 45, 83, 11, 9, 101);
$series2->keys(\@keys2);
$series2->values(\@vals2);

my $series3 = new Chart::Clicker::Data::Series();
my @keys3 = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
my @vals3 = (56, 52, 68, 32, 98, 1, 67, 21, 45, 33);
$series3->keys(\@keys3);
$series3->values(\@vals3);

my $series4 = new Chart::Clicker::Data::Series();
my @keys4 = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
my @vals4 = (12, 9, 90, 78, 24, 34, 89, 56, 65, 3);
$series4->keys(\@keys4);
$series4->values(\@vals4);

my $dataset = new Chart::Clicker::Data::DataSet();
$dataset->series([ $series ]);

my $dataset2 = new Chart::Clicker::Data::DataSet();
$dataset2->series([ $series2 ]);

my $dataset3 = new Chart::Clicker::Data::DataSet();
$dataset3->series([ $series3 ]);

my $dataset4 = new Chart::Clicker::Data::DataSet();
$dataset4->series([ $series4 ]);

$chart->datasets([ $dataset, $dataset2, $dataset3, $dataset4 ]);

my $legend = new Chart::Clicker::Decoration::Legend({
    margins => new Chart::Clicker::Drawing::Insets({
        top => 3
    })
});
ok(defined($legend), 'new Legend');

$chart->add($legend, $CC_TOP);

my $daxis = new Chart::Clicker::Axis({
    orientation => $CC_HORIZONTAL,
    position => $CC_TOP
});
my $tlabel = new Chart::Clicker::Decoration::Label({ text => 'Danes', orientation => $CC_HORIZONTAL});
$chart->add($tlabel, $CC_TOP);

my $label = new Chart::Clicker::Decoration::Label({text => 'Footballs', orientation => $CC_VERTICAL});
$chart->add($label, $CC_LEFT);

my $raxis = new Chart::Clicker::Axis({
    orientation => $CC_VERTICAL,
    position => $CC_LEFT
});
ok(defined($raxis), 'new Axis');

$chart->add($daxis, $CC_AXIS_TOP);
$chart->add($raxis, $CC_AXIS_LEFT);

$chart->range_axes([ $raxis ]);
$chart->domain_axes([ $daxis ]);

my $grid = new Chart::Clicker::Decoration::Grid();
$chart->add($grid, $CC_CENTER, 0);

my $plot = $chart->plot();
#$chart->plot($plot);
$chart->add($plot, $CC_CENTER);
ok(defined($plot), 'new Plot');

my $area = new Chart::Clicker::Renderer::Area(
    fade => 1,
    stroke => new Chart::Clicker::Drawing::Stroke({
        width => 2
    })
);
ok(defined($area), 'new Renderer');
my $point = new Chart::Clicker::Renderer::Point();
my $line = new Chart::Clicker::Renderer::Line();
$plot->renderers([$area, $point, $line]);

$chart->prepare();
my $surf = $chart->draw();
#$chart->write('/Users/gphat/test.png');
