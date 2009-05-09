#!/usr/bin/perl
use strict;

use Chart::Clicker;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Series::HighLow;
use Chart::Clicker::Renderer::CandleStick;
use Graphics::Color::RGB;

my $cc = Chart::Clicker->new(width => 500, height => 250, format => 'png');

my @hours = qw(

);

my $series1 = Chart::Clicker::Data::Series::HighLow->new(
    keys    => [qw(1 2 3 4 5 6 7 8 9 10)],
    highs   => [qw(5 9 7 8 8 9 5 4 7 9)],

    lows    => [qw(1 4 2 3 1 4 1 1 1 4)],
    opens   => [qw(3 5 4 6 4 8 4 1 1 6)],
    values  => [qw(5 4 6 4 8 4 1 1 6 9)]
);

# We'll create a dataset with our first two series in it...
my $ds = Chart::Clicker::Data::DataSet->new(
    series => [ $series1 ]
);

# Pretty stuff
$cc->border->width(0);

# Add the datasets to the chart
$cc->add_to_datasets($ds);

# Set some labels on the default context
my $defctx = $cc->get_context('default');
$defctx->range_axis->label('Lorem');
$defctx->range_axis->fudge_amount(.2);
$defctx->domain_axis->label('Ipsum');
$defctx->domain_axis->tick_label_angle(0.785398163);
$defctx->domain_axis->fudge_amount(.06);

# Here's the magic: You can set a renderer for any context.  In this case
# we'll change the default to a Bar.  Voila!
$defctx->renderer(Chart::Clicker::Renderer::CandleStick->new(bar_padding => 30));

$cc->draw;
$cc->write('foo.png');
