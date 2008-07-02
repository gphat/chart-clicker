use Test::More tests => 2;

use Chart::Clicker;
use Chart::Clicker::Axis;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Decoration::Grid;
use Chart::Clicker::Decoration::Legend;
use Chart::Clicker::Decoration::Plot;
use Chart::Clicker::Drawing qw(:positions);
use Chart::Clicker::Renderer::Area;

my $chart = Chart::Clicker->new({ format => 'Png', width => 500, height => 350 });

my $series = Chart::Clicker::Data::Series->new({
  keys    => [1, 2, 3, 4, 5, 6],
  values  => [12, 9, 8, 3, 5, 1]
});

my $dataset = Chart::Clicker::Data::DataSet->new({
  series => [ $series ]
});
$chart->datasets([ $dataset ]);

my $legend = Chart::Clicker::Decoration::Legend->new();
$chart->add_component($legend, 's');

my $daxis = Chart::Clicker::Axis->new({
  orientation => $CC_HORIZONTAL,
  position    => $CC_BOTTOM,
  format      => '%0.2f'
});
$chart->add_component($daxis, 's');

my $raxis = Chart::Clicker::Axis->new({
  orientation => $CC_VERTICAL,
  position    => $CC_LEFT,
  format      => '%0.2f'
});
$chart->add_component($raxis, 'w');

$chart->range_axes([ $raxis ]);
$chart->domain_axes([ $daxis ]);

my $grid = Chart::Clicker::Decoration::Grid->new();
# $chart->add_component($grid, 'c');

my $renderer = Chart::Clicker::Renderer::Area->new(fade => 1);

my $plot = Chart::Clicker::Decoration::Plot->new();
$plot->renderers([$renderer]);
# TODO Shouldn't have to do this here.
# $plot->add_component($renderer);

$chart->plot($plot);

# $chart->add_component($plot, 'center');

$chart->prepare();
$chart->do_layout($chart);
$chart->draw();
$chart->write('/Users/gphat/chart.png');

my $range = $chart->get_dataset(0)->get_series(0)->range;
cmp_ok($range->lower(), '==', 1, 'Lower is 1');
cmp_ok($raxis->range->lower(), 'eq', $range->lower(), 'series lower = axis lower');

