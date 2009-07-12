#!/usr/bin/perl
use strict;

use Chart::Clicker;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Series;

my $cc = Chart::Clicker->new(width => 500, height => 400);

my $series1 = Chart::Clicker::Data::Series->new(
    keys    => [qw(1 2 3 4 5 6 7 8 9 10 11 12)],
    values  => [qw(5.8 5.0 4.9 4.8 4.5 4.25 3.5 2.9 2.5 1.8 .9 .8)]
);

my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series1 ]);

$cc->add_to_datasets($ds);

$cc->write_output('foo.png');
