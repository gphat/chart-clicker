#!/usr/bin/perl
use strict;

use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Renderer::Point;
use Geometry::Primitive::Rectangle;
use Graphics::Color::RGB;

my $cc = Chart::Clicker->new(width => 75, height => 18, format => 'png');

my $series = Chart::Clicker::Data::Series->new(
  keys    => [   1,   2,   3,   4,   5,    6,   7,   8,   9,  10, 11, 12, 13,  14,  15,  16,  17,  18,  19,   20,  21,  22,  23,  24],
  values  => [ 5.8, 5.0, 4.9, 4.8, 4.5, 4.25, 3.5, 2.9, 2.5, 1.8, .9, .8, .7, 1.1, 1.7, 2.5, 3.0, 4.5, 5.0,  4.9, 4.7, 4.8, 4.2, 4.4],
);
my $series2 = Chart::Clicker::Data::Series->new(
	keys => [ 24 ],
	values => [ 4.4 ]
);
my $series3 = Chart::Clicker::Data::Series->new(
	keys => [ 1, 13 ],
	values => [ 5.8, .7 ]
);


my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series ]);

$cc->add_to_datasets($ds);

my $defctx = $cc->get_context('default');

my $highds = Chart::Clicker::Data::DataSet->new(series => [ $series2 ]);
$cc->add_to_datasets($highds);

my $highctx = Chart::Clicker::Context->new(
  name => 'high',
  renderer => Chart::Clicker::Renderer::Point->new(
      shape => Geometry::Primitive::Rectangle->new(
          width => 3,
          height => 3
      )
  ),
  range_axis => $defctx->range_axis,
  domain_axis => $defctx->domain_axis
);
$cc->add_to_contexts($highctx);
$highds->context('high');
# 
my $noteds = Chart::Clicker::Data::DataSet->new(series => [ $series3 ]);
$cc->add_to_datasets($noteds);

my $notectx = Chart::Clicker::Context->new(
  name => 'notable',
  renderer => Chart::Clicker::Renderer::Point->new(
      shape => Geometry::Primitive::Rectangle->new(
          width => 3,
          height => 3
      )
  ),
  range_axis => $defctx->range_axis,
  domain_axis => $defctx->domain_axis
);
$cc->add_to_contexts($notectx);
$noteds->context('notable');

my $grey = Graphics::Color::RGB->new(
	red => .36, green => .36, blue => .36, alpha => 1
);
my $red = Graphics::Color::RGB->new(
	red => 1, green => 0, blue => 0
);
my $blue = Graphics::Color::RGB->new(
	red => .2, green => .6, blue => 1
);

my $mark = Chart::Clicker::Data::Marker->new(value => 2, value2 => 4);
$mark->brush->color(
    Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => .15)
);
$mark->inside_color(
    Graphics::Color::RGB->new(red => 0, green => 0, blue => 0, alpha => .15)
);
$defctx->add_marker($mark);

$cc->color_allocator->colors([ $grey, $red, $blue ]);

$cc->plot->grid->visible(0);
$cc->legend->visible(0);
$cc->padding(2);
$cc->border->width(0);

$defctx->range_axis->hidden(1);
$defctx->range_axis->fudge_amount(.2);
$defctx->domain_axis->hidden(1);
$defctx->domain_axis->fudge_amount(.1);
$defctx->renderer->brush->width(1);

$cc->write_output('foo.png')