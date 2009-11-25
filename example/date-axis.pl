#!/usr/bin/perl
use strict;

use Chart::Clicker;
use Chart::Clicker::Axis::DateTime;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Series;

my $cc = Chart::Clicker->new(width => 500, height => 400);

my $series1 = Chart::Clicker::Data::Series->new(
    values => [qw(1 2 3 4 5 6 7 8 9 10 11 12)],
    keys  => [qw(
        1257069600
        1257156000
        1257242400
        1257328800
        1257415200
        1257501600
        1257588000
        1257674400
        1257760800
        1257847200
        1257933600
        1258020000
    )]
);

my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series1 ]);

$cc->add_to_datasets($ds);

my $def = $cc->get_context('default');

my $dtaxis = Chart::Clicker::Axis::DateTime->new(
    format => '%m/%d',
    position => 'bottom',
    orientation => 'horizontal'
);
$def->domain_axis($dtaxis);

$cc->write_output('foo.png');