#!/usr/bin/perl

use strict;

use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Decoration::Annotation;
use Geometry::Primitive::Rectangle;
use Geometry::Primitive::Point;
use Graphics::Primitive::Border;
use Graphics::Primitive::TextBox;
use Graphics::Primitive::Insets;
use Graphics::Color::RGB;

my $cc = Chart::Clicker->new(width => 500, height => 400, format => 'png');

my @hours = qw(
    1 2 3 4 5 6 7 8 9 10 11 12
);
my @bw1 = qw(
    5.8 5.0 4.9 4.8 4.5 4.25 3.5 2.9 2.5 1.8 .9 .8
);
my @bw2 = qw(
    .7 1.1 1.7 2.5 3.0 4.5 5.0 4.9 4.7 4.8 4.2 4.4
);
my @bw3 = qw(
    .3 1.4 1.2 1.5 4.0 3.5 2.0 1.9 2.7 4.2 3.2 1.1
);

my $series1 = Chart::Clicker::Data::Series->new(
    keys    => \@hours,
    values  => \@bw1,
);
my $series2 = Chart::Clicker::Data::Series->new(
    keys    => \@hours,
    values  => \@bw2,
);

# We'll create a dataset with our first two series in it...
my $ds = Chart::Clicker::Data::DataSet->new(
    series => [ $series1, $series2 ]
);

# We'll put the third into it's own dataset so we can put it in a new context
my $series3 = Chart::Clicker::Data::Series->new(
    keys    => \@hours,
    values  => \@bw3,
);
my $ds1 = Chart::Clicker::Data::DataSet->new(
    series => [ $series3 ]
);

# Create a new context
my $other_context = Chart::Clicker::Context->new(
    name => 'other'
);
# Set it's labels...
$other_context->range_axis->label('Solor');
$other_context->domain_axis->label('Amet');

# Instruct the ds1 dataset to use the 'other' context.  DataSets default to
# the 'default' context.
$ds1->context('other');
$cc->add_to_contexts($other_context);

# Pretty stuff
$cc->border->width(0);

# Add the datasets to the chart
$cc->add_to_datasets($ds);
$cc->add_to_datasets($ds1);

# Set some labels on the default context
my $defctx = $cc->get_context('default');
$defctx->range_axis->label('Lorem');
$defctx->domain_axis->label('Ipsum');
$defctx->domain_axis->tick_label_angle(0.785398163);
$defctx->renderer->brush->width(1);

$cc->add_to_over_decorations(
    Chart::Clicker::Decoration::Annotation->new(
        key => $hours[2], value => $bw1[2], 
        text => sprintf("value: %s", $bw1[2]),
        context => 'default',
    )
);
$cc->add_to_over_decorations(
    Chart::Clicker::Decoration::Annotation->new(
        key => $hours[4], value => $bw2[4], 
        text => sprintf("(%s, %s)", $hours[4], $bw2[4]),
        context => 'default',
        padding => Graphics::Primitive::Insets->new(
            top => 5, bottom => 5, left => 5, right => 5,
        ),
        border => Graphics::Primitive::Border->new(
            color
                => Graphics::Color::RGB->from_hex_string('#000000'),
            width => 2,
        ),
    )
);
$cc->add_to_over_decorations(
    Chart::Clicker::Decoration::Annotation->new(
        key => $hours[9], value => $bw3[9], 
        text => sprintf("(%s, %s)", $hours[9], $bw3[9]),
        context => 'other',
        background_color
            => Graphics::Color::RGB->from_hex_string('#000000'),
        color
            => Graphics::Color::RGB->from_hex_string('#ffffff'),
        offset => Geometry::Primitive::Point->new( x => 10, y => 0 ),

    )
);

$cc->write_output('foo.png');
