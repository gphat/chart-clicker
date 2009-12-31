#!/usr/bin/perl
use strict;

use Chart::Clicker;
use Chart::Clicker::Renderer::Point;

my $cc = Chart::Clicker->new(width => 500, height => 250);

my @bw1 = qw(
    5 5 4 4 4 4 3 2 2 1 99 100
);
my @bw2 = qw(
    .7 1.1 1.7 2.5 3.0 4.5 15.0 4.9 4.7 4.8 4.2 4.4
);
my @bw3 = qw(
    .3 1.4 1.2 1.5 4.0 3.5 2.0 1.9 2.7 4.2 3.2 1.1
);

foreach my $d (@bw1) {
    $cc->add_data('Series 0', $d);
}
foreach my $d (@bw2) {
    $cc->add_data('Series 1', $d);
}
foreach my $d (@bw3) {
    $cc->add_data('Series 2', $d);
}

my $def = $cc->get_context('default');

my $ren = Chart::Clicker::Renderer::Point->new;
$cc->get_context('default')->renderer($ren);
$def->range_axis->skip_range(Chart::Clicker::Data::Range->new(lower => 20, upper => 95));
$def->range_axis->format('%d');
$def->domain_axis->tick_values([qw(2 4 6 8 10)]);
$def->domain_axis->format('%d');

$cc->write_output('foo.png');
