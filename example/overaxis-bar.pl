#!/usr/bin/perl
use strict;

use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Decoration::OverAxis;
use Chart::Clicker::Renderer::Bar;
use Geometry::Primitive::Rectangle;
use Graphics::Color::RGB;

my $cc = Chart::Clicker->new(width => 300, height => 150);

my @years = qw(
    1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009
);
my @top = qw(
    8    7    2    5    9    5    7    3    5    7    9
);
my @bottom = qw(
    -4   -2   -7   -9   -5   -7   -5   -5   -3   -9   -7
);


my $series = Chart::Clicker::Data::Series->new(
    keys    => \@years,
    values  => \@top,
);

my $series2 = Chart::Clicker::Data::Series->new(
    keys    => \@years,
    values  => \@bottom,
);

my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series, $series2 ]);

$cc->add_to_datasets($ds);

my $defctx = $cc->get_context('default');

my $grey = Graphics::Color::RGB->new(
    red => .36, green => .36, blue => .36, alpha => 1
);
my $red = Graphics::Color::RGB->new(
    red => .71, green => .71, blue => .71, alpha => 1
);


$cc->color_allocator->colors([ $grey, $red ]);
$cc->border->width(0);

$cc->plot->grid->visible(0);
$cc->legend->visible(0);

$defctx->renderer(Chart::Clicker::Renderer::Bar->new);

$defctx->range_axis->baseline(0);
$defctx->range_axis->hidden(1);
$defctx->domain_axis->hidden(1);
$defctx->domain_axis->fudge_amount(.1);
$defctx->renderer->brush->width(1);
$defctx->domain_axis->tick_values([qw(2000 2002 2004 2006 2008)]);

$cc->add_to_over_decorations(Chart::Clicker::Decoration::OverAxis->new(context => 'default'));

$cc->draw;
$cc->write('foo.png');