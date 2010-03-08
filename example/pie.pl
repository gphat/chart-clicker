#!/usr/bin/perl
use strict;

use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Renderer::Pie;
use Geometry::Primitive::Rectangle;
use Graphics::Color::RGB;

my $cc = Chart::Clicker->new(width => 300, height => 250);

my $series1 = Chart::Clicker::Data::Series->new(
    keys    => [ 1, 2, 3 ],
    values  => [ 1, 2, 3 ],
);
my $series2 = Chart::Clicker::Data::Series->new(
    keys    => [ 1, 2, 3],
    values  => [ 1, 1, 3 ],
);
my $series3 = Chart::Clicker::Data::Series->new(
    keys    => [ 1, 2, 3],
    values  => [ 1, 2, 1 ],
);
my $series4 = Chart::Clicker::Data::Series->new(
    keys    => [ 1, 2, 3],
    values  => [ 1, 2, 3 ],
);


my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series1, $series2, $series3, $series4 ]);

$cc->add_to_datasets($ds);

my $defctx = $cc->get_context('default');
my $ren = Chart::Clicker::Renderer::Pie->new;
$ren->border_color(Graphics::Color::RGB->new(red => 0, green => 0, blue => 0));
$ren->brush->width(2);
$ren->gradient_color(Graphics::Color::RGB->new(red => 1, green => 1, blue => 1, alpha => .3));
$defctx->renderer($ren);
$defctx->domain_axis->hidden(1);
$defctx->range_axis->hidden(1);
$cc->plot->grid->visible(0);

$cc->write_output('foo.png');
