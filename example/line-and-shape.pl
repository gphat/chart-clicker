#!/usr/bin/perl
use strict;

use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Renderer::Line;
use Geometry::Primitive::Circle;
use Geometry::Primitive::Rectangle;
use Graphics::Color::RGB;

my $cc = Chart::Clicker->new(width => 500, height => 250, format => 'png');

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

$cc->background_color(
    # Graphics::Color::RGB->new(red => .95, green => .94, blue => .92)
);
$cc->color_allocator->colors([ $grey ]);

# $defctx->range_axis->label('FOOO');
$defctx->range_axis->fudge_amount(.2);
#$defctx->domain_axis->hidden(1);
# $defctx->domain_axis->label("WEEE");
$defctx->domain_axis->fudge_amount(.1);
$defctx->domain_axis->tick_label_angle(0.785398163);
$defctx->renderer(Chart::Clicker::Renderer::Line->new);
$defctx->renderer->shape(
    Geometry::Primitive::Circle->new({
       radius => 5,
    })
);
$defctx->renderer->shape_brush(
    Graphics::Primitive::Brush->new(
        width => 2,
        color => Graphics::Color::RGB->new(red => .9, green => .9, blue => .9, alpha => 1)
    )
);
$defctx->renderer->brush->width(2);

$cc->draw;
$cc->write('foo.png');
