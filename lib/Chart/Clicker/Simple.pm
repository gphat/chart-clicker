package Chart::Clicker::Simple;
use Moose;

use Chart::Clicker;
use Chart::Clicker::Axis;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Decoration::Grid;
use Chart::Clicker::Decoration::Label;
use Chart::Clicker::Decoration::Legend;
use Chart::Clicker::Decoration::Plot;
use Chart::Clicker::Drawing qw(:positions);
use Chart::Clicker::Drawing::Insets;

has 'chart' => ( is => 'rw', isa => 'Chart::Clicker' );
has 'data' => ( is => 'rw', isa => 'ArrayRef', default => sub { [] });
has 'domain_label' => ( is => 'rw', isa => 'Str' );
has 'height' => ( is => 'rw', isa => 'Int', default => 300 );
has 'range_label' => ( is => 'rw', isa => 'Str' );
has 'renderer' => (
    is => 'rw',
    isa => 'Chart::Clicker::Renderer::Base',
    default => sub { new Chart::Clicker::Renderer::Line() }
);
has 'width' => ( is => 'rw', isa => 'Int', default => 400 );
has 'hide_axes' => ( is => 'rw', isa => 'Bool', default => 0 );
has 'hide_grid' => ( is => 'rw', isa => 'Bool', default => 0 );
has 'range_baseline' => ( is => 'rw', isa => 'Num' );
has 'format' => ( is => 'ro', isa => 'Format', coerce => 1, default => sub {
    Chart::Clicker::Format::Png->new()
} );
has 'domain_tick_format' => ( is => 'ro', isa => 'Str', default => '%s' );
has 'domain_tick_values' => ( is => 'ro', isa => 'ArrayRef', default => sub { [] } );
has 'domain_tick_labels' => ( is => 'ro', isa => 'ArrayRef', default => sub { [] } );
has 'range_tick_format' => ( is => 'ro', isa => 'Str', default => '%s' );

sub BUILD {
    my ($self, $args) = @_;

    my @serieses;
    foreach my $d (@{ $self->data() }) {
        my $series = new Chart::Clicker::Data::Series({
            keys    => $d->{'keys'},
            values  => $d->{'values'}
        });
        push(@serieses, $series);
    }

    my $chart = new Chart::Clicker({
        format              => $self->format(),
        width               => $self->width(),
        height              => $self->height(),
        datasets            => [
            new Chart::Clicker::Data::DataSet({
                series => \@serieses
            })
        ]
    });

    $chart->add(
        new Chart::Clicker::Decoration::Legend({
            margins => new Chart::Clicker::Drawing::Insets({
                top => 3
            })
        }), $CC_BOTTOM
    );

    # Domain Axis
    my $daxis = new Chart::Clicker::Axis({
        orientation => $CC_HORIZONTAL,
        position    => $CC_BOTTOM,
        label       => $self->domain_label(),
        visible     => !$self->hide_axes()
    });
    $daxis->format($self->domain_tick_format());
    if(defined($self->domain_tick_values())) {
        $daxis->tick_values($self->domain_tick_values());
        $daxis->tick_labels($self->domain_tick_labels());
    }

    $chart->add($daxis, $CC_AXIS_BOTTOM);

    # Range Axis
    my $raxis = new Chart::Clicker::Axis({
        orientation => $CC_VERTICAL,
        position    => $CC_LEFT,
        label       => $self->range_label(),
        visible     => !$self->hide_axes(),
    });

	if(defined($self->range_baseline())) {
		$raxis->baseline($self->range_baseline());
	}

    $raxis->format($self->range_tick_format());
    $chart->add($raxis, $CC_AXIS_LEFT);

    $chart->range_axes([ $raxis ]);
    $chart->domain_axes([ $daxis ]);

    # Grid
    unless($self->hide_grid()) {
        $chart->add(new Chart::Clicker::Decoration::Grid(), $CC_CENTER, 0);
    }

    # Plot
	my $plot = $chart->plot();
    $plot->renderers([ $self->renderer() ]);
    unless(defined($self->renderer())) {
        die('Please provider a renderer!');
    }

    $chart->add($plot, $CC_CENTER);

    #$plot->set_renderer_for_dataset(0, 0);

    $chart->prepare();

    $self->chart($chart);
}

1;

__END__

=head1 NAME

Chart::Clicker::Simple - Simple Clicker Chart

=head1 DESCRIPTION

Clicker's API can be a bit daunting for simple work.  This class aims to make
it a bit more simple.

=head1 SYNOPSIS

 use Chart::Clicker::Simple;
 use Chart::Clicker::Line;

 my $simple = new Chart::Clicker::Simple({
    # Add two sets of data!
    data => [
        {
            keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
            values  => [ 2, 6, 8, 3, 5, 9, 1, 3, 1, 7 ]
        },
        {
            keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
            values  => [ 4, 4, 5, 8, 12, 7, 0, 5, 4, 10 ]
        }
    ],
    domain_label    => 'Danes',
    range_label     => 'Footballs',
    renderer        => new Chart::Clicker::Renderer::Line()
 });
 $simple->draw();

=cut

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Chart::Clicker::Simple object.  You can specify the following
values in the hash to influence the underlying Chart::Clicker object:

=over 4

=item data

An arrayref of hashrefs.  Each hashref should have the two keys; one named
keys and the other values.  These two keys should contain arrayrefs that
contain the data.  See the Synopsis for an example.

=item domain_label

The label for the domain axis.

=item range_label

The label for the range axis.

=item height

Height of the chart.

=item width

Width of the chart.

=item hide_grid

Set to true to hide the grid.

=item hide_axes

Set to true to hide the hide the axes.

=item renderer

Required!  The renderer to use for this chart.

=back

=back

=head2 Class Methods

None.

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

Chart::Clicker

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
