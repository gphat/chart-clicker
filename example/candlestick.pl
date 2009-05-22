#!/usr/bin/perl
use strict;

use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Data::Series::HighLow;
use Chart::Clicker::Renderer::CandleStick;
use Geometry::Primitive::Rectangle;
use Graphics::Color::RGB;

my $cc = Chart::Clicker->new(width => 500, height => 250);

my $series1 = Chart::Clicker::Data::Series::HighLow->new(
    keys    => [qw(1 2 3 4 5 6 7 8 9 10)],

    highs   => [qw(5 9 7 8 8 9 5 4 7 9)],
    opens   => [qw(3 5 4 6 4 8 4 1 1 6)],
    values  => [qw(5 4 6 4 8 4 1 1 6 9)],
    lows    => [qw(1 4 2 3 1 4 1 1 1 4)],
);

my $series2 = Chart::Clicker::Data::Series::HighLow->new(
    keys    => [qw(1 2 3 4 5 6 7 8 9 10)],

    highs   => [qw(9 7 9 7 9 8 6 6 8 9)],
    opens   => [qw(3 6 4 6 4 8 4 1 1 6)],
    values  => [qw(6 4 6 4 8 4 1 1 6 9)],
    lows    => [qw(3 4 2 3 3 4 1 1 1 4)],
);

my $series3 = Chart::Clicker::Data::Series::HighLow->new(
    keys    => [qw(1 2 3 4 5 6 7 8 9 10)],

    highs   => [qw(8 8 5 4 3 8 9 9 6 4)],
    opens   => [qw(3 7 3 2 1 2 7 9 5 2)],
    values  => [qw(7 3 2 1 2 7 9 5 2 3)],
    lows    => [qw(1 2 2 0 1 4 1 1 1 4)],
);

my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series1, $series2, $series3 ]);

$cc->add_to_datasets($ds);

my $def = $cc->get_context('default');

my $ren = Chart::Clicker::Renderer::CandleStick->new;
$def->renderer($ren);
$def->range_axis->tick_values([qw(1 4 7)]);
$def->range_axis->format('%d');
$def->domain_axis->fudge_amount(.05);
$def->domain_axis->tick_values([qw(2 4 6 8 10)]);
$def->domain_axis->format('%d');

$cc->draw;
$cc->write('foo.png');
