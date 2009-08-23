#!/usr/bin/perl
use strict;

use Chart::Clicker;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Decoration::Legend::Tabular;

use List::Util qw(max min);
use Statistics::Basic qw(median mean);

my $cc = Chart::Clicker->new(width => 500, height => 400);

my $series1 = Chart::Clicker::Data::Series->new(
    keys    => [qw(1 2 3 4 5 6 7 8 9 10 11 12)],
    values  => [qw(5.8 5.0 4.9 4.8 4.5 4.25 3.5 2.9 2.5 1.8 .9 .8)]
);
my $series2 = Chart::Clicker::Data::Series->new(
    keys    => [qw(1 2 3 4 5 6 7 8 9 10 11 12)],
    values  => [qw(8.5 0.5 9.4 8.4 5.4 2.5 5.3 9.2 5.2 8.1 1.9 1.8)]
);

my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series1, $series2 ]);

$cc->legend(Chart::Clicker::Decoration::Legend::Tabular->new(
    header => [ qw(Name Min Max Median Mean) ],
    data => [
        [ min(@{ $series1->values }), max(@{ $series1->values }), median($series1->values)."", mean($series1->values)."" ],
        [ min(@{ $series2->values }), max(@{ $series2->values }), median($series2->values)."", mean($series2->values)."" ]
    ]
));

$cc->add_to_datasets($ds);

$cc->write_output('foo.png');
