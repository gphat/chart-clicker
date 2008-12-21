use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Renderer::Point;
use Geometry::Primitive::Rectangle;
use Graphics::Color::RGB;

my $cc = Chart::Clicker->new(width => 500, height => 200);

my @hours = qw(
    1 2 3 4 5 6 7 8 9 10 11 12
    13 14 15 16 17 18 19 20 21 22 23 24
);
my @bw = qw(
    5.8 5.0 4.9 4.8 4.5 4.25 3.5 2.9 2.5 1.8 .9 .8
    .7 1.1 1.7 2.5 3.0 4.5 5.0 4.9 4.7 4.8 4.2 4.4
);

my $series = Chart::Clicker::Data::Series->new(
    keys    => \@hours,
    values  => \@bw,
);

my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series ]);

$cc->add_to_datasets($ds);

my $defctx = $cc->get_context('default');

my $grey = Graphics::Color::RGB->new(
    red => .36, green => .36, blue => .36, alpha => 1
);

$cc->color_allocator->colors([ $grey, $green, $blue ]);

$cc->grid_over(1);
$cc->plot->grid->range_brush->width(5);
$cc->plot->grid->show_domain(1);
$cc->plot->grid->domain_brush->color(
    Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => .10)
);

$cc->legend->visible(0);

$cc->plot->grid->range_brush->color(
    Graphics::Color::RGB->new(red => 1, green => 1, blue => 1)
);

$cc->legend_position('n');
$defctx->range_axis->fudge_amount(.015);
$defctx->range_axis->tick_values([qw(1 2 3 4 5)]);
$defctx->range_axis->format('%d');
$defctx->domain_axis->brush->width(0);
$defctx->domain_axis->tick_values([qw(3 6 9 12 15 18 21)]);
$defctx->domain_axis->format('%d');

$defctx->domain_axis->fudge_amount(.015);
$defctx->range_axis->brush->width(0);

# $defctx->domain_axis->tick_label_angle(0.785398163);
$defctx->renderer->brush->width(3);

$cc->draw;
$cc->write('foo.png');
