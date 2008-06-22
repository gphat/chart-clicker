use Test::More tests => 25;

BEGIN {
    use_ok('Chart::Clicker');
    use_ok('Chart::Clicker::Axis');
    use_ok('Chart::Clicker::Data::DataSet');
    use_ok('Chart::Clicker::Data::Marker');
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

my $chart = new Chart::Clicker({ width => 800, height => 600 });
ok(defined($chart), 'new Chart::Clicker');

my $series = new Chart::Clicker::Data::Series();
my @keys = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
my @vals = (42, 25, 86, 23, 2, 19, 10, 12, 540, 9);
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

my $dataset = Chart::Clicker::Data::DataSet->new(series => [ $series ]);
$chart->add_to_datasets($dataset);

my $dataset2 = Chart::Clicker::Data::DataSet->new(series => [ $series2 ]);
$chart->add_to_datasets($dataset2);

my $dataset3 = Chart::Clicker::Data::DataSet->new(series => [ $series3 ]);
$chart->add_to_datasets($dataset3);

my $dataset4 = Chart::Clicker::Data::DataSet->new(series => [ $series4 ]);
$chart->add_to_datasets($dataset4);

# $chart->datasets([ $dataset, $dataset2, $dataset3, $dataset4 ]);

my $legend = new Chart::Clicker::Decoration::Legend({
    margins => new Chart::Clicker::Drawing::Insets({
        top => 3
    })
});
ok(defined($legend), 'new Legend');

$chart->add($legend, $CC_BOTTOM);

my $format = '%0.2f';

my $daxis = new Chart::Clicker::Axis({
    orientation => $CC_HORIZONTAL,
    position    => $CC_TOP,
    format      => $format
});
my $tlabel = new Chart::Clicker::Decoration::Label({ text => 'Danes', orientation => $CC_HORIZONTAL});
$chart->add($tlabel, $CC_TOP);

my $label = new Chart::Clicker::Decoration::Label({text => 'Footballs', orientation => $CC_VERTICAL});
$chart->add($label, $CC_LEFT);

my $daxis2 = new Chart::Clicker::Axis({
    orientation => $CC_HORIZONTAL,
    position    => $CC_BOTTOM,
    format      => $format
});

my $raxis = new Chart::Clicker::Axis({
    orientation => $CC_VERTICAL,
    position    => $CC_LEFT,
    format      => $format
});
ok(defined($raxis), 'new Axis');

my $raxis2 = new Chart::Clicker::Axis({
    orientation => $CC_VERTICAL,
    position    => $CC_RIGHT,
    format      => $format
});

$chart->add($daxis2, $CC_AXIS_BOTTOM);
$chart->add($raxis2, $CC_AXIS_RIGHT);
$chart->add($daxis, $CC_AXIS_TOP);
$chart->add($raxis, $CC_AXIS_LEFT);

$chart->range_axes([ $raxis, $raxis2 ]);
$chart->domain_axes([ $daxis, $daxis2 ]);

$chart->set_dataset_range_axis(2, 1);
$chart->set_dataset_domain_axis(2, 1);

cmp_ok($chart->get_dataset_range_axis(1), '==', 0, 'First dataset is on 0 range');
cmp_ok($chart->get_dataset_range_axis(2), '==', 1, 'Second dataset is on 1 range');

my $grid = new Chart::Clicker::Decoration::Grid();
$chart->add($grid, $CC_CENTER, 0);

my $plot = $chart->plot();
$chart->add($plot, $CC_CENTER);
ok(defined($plot), 'new Plot');

my $dmark = new Chart::Clicker::Data::Marker({
    key => 6,
    key2 => 8,
});
$chart->markers([ $dmark ]);
my $rmark = new Chart::Clicker::Data::Marker({
    value => 225,
    value2 => 320
});
$chart->add_to_markers($rmark);
$chart->set_marker_range_axis(0, 1);
cmp_ok($chart->get_marker_range_axis(0), '==', 1, 'Marker range axis');
# $chart->set_marker_domain_axis(1,);
cmp_ok($chart->get_marker_domain_axis(0), '==', 0, 'Marker domain axis');
cmp_ok($chart->marker_count(), '==', 2, 'Marker count');

my $area = new Chart::Clicker::Renderer::Area(
    fade => 1,
    stroke => new Chart::Clicker::Drawing::Stroke({
        width => 2
    })
);
ok(defined($area), 'new Renderer');
my $point = new Chart::Clicker::Renderer::Point();
my $line = new Chart::Clicker::Renderer::Line();
my $bar = new Chart::Clicker::Renderer::Bar(opacity => .60);

$plot->renderers([$area, $point, $line, $bar]);
$plot->set_renderer_for_dataset(1, 1);
$plot->set_renderer_for_dataset(2, 2);
$plot->set_renderer_for_dataset(3, 3);

$chart->prepare();
my $surf = $chart->draw();
$chart->write('/Users/gphat/test.png');
