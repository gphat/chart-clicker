package Chart::Clicker::Renderer::PolarArea;
use Moose;

extends 'Chart::Clicker::Renderer';

use Graphics::Color::RGB;
use Geometry::Primitive::Arc;
use Graphics::Primitive::Brush;

use Scalar::Util qw(refaddr);

has 'border_color' => (
    is => 'rw',
    isa => 'Graphics::Color::RGB',
    default => sub { Graphics::Color::RGB->new },
);
has 'brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub { Graphics::Primitive::Brush->new }
);
has 'center_radius' => (
    is => 'rw',
    isa => 'Num',
    default => 5
);
has '_accum' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] }
);
has '_colors' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] }
);
has '_largest' => (
    is => 'rw',
    isa => 'Num',
    default => 0
);

my $TO_RAD = (4 * atan2(1, 1)) / 180;

override('prepare', sub {
    my $self = shift;

    super;

    my $clicker = $self->clicker;

    # TODO
    # This implementation is dumb... the better way would be:
    # draw the first slice
    # remember once of the corner points
    # when drawing the next slice, start at the remembered point and arc-neg with no radius
    # then arc pos again
    # or something like that

    # This is really hinky, basically since figuring out the arcs and whatnot
    # is a pain in the ass, we employ the painter's algorithm and draw
    # the last series first, the pain the next one over it.  As such, we have
    # to know the total "accumulated" value for each series' position so that
    # we can decrement it on each run through the series... this finds the
    # totals
    my $dses = $clicker->get_datasets_for_context($self->context);
    foreach my $ds (@{ $dses }) {

        my $lvs = $ds->largest_value_slice;
        if($lvs > $self->_largest) {
            $self->_largest($lvs)
        }

        my $count = $ds->max_key_count;
        for(0..$count - 1) {
            my $pos = $_;
            my @vals = $ds->get_series_values($pos);
            my $total = 0;
            foreach my $v (@vals) {
                $total += $v;
            }
            $self->_accum->[$pos] += $total;
        }
    }

});

override('finalize', sub {
    my $self = shift;

    my $clicker = $self->clicker;

    my $radius = $self->height;
    if($self->width < $self->height) {
        $radius = $self->width;
    }

    $radius = $radius / 2;

    # Take into account the line around the edge when working out the radius
    $radius -= $self->brush->width;

    my $height = $self->height;
    my $linewidth = 1;
    my $midx = $self->width / 2;
    my $midy = $height / 2;

    my $per = $radius / $self->_largest;

    my $dses = $clicker->get_datasets_for_context($self->context);

    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series }) {
            push(@{ $self->_colors }, $clicker->color_allocator->next);
        }
    }

    # my $dses = $clicker->get_datasets_for_context($self->context);
    foreach my $ds (reverse @{ $dses }) {

        my $ctx = $clicker->get_context($ds->context);
        my $domain = $ctx->domain_axis;
        my $range = $ctx->range_axis;

        foreach my $series (reverse @{ $ds->series }) {

            my $pos = 0;

            my $degs = 360 / scalar(@{ $series->values });

            my $color = pop(@{ $self->_colors });

            my $v = 0;
            foreach my $val (@{ $series->values }) {

                my $foo = $self->_accum->[$v];

                # Remove this value worth of accumulate from the accumulator
                # so that our size is properly pushed out, see above comment
                # in prepare...
                $self->_accum->[$v] -= $val;

                $self->move_to($midx, $midy);
                $self->arc(($self->_accum->[$v] + $val) * $per, ($pos - $degs) * $TO_RAD, $pos * $TO_RAD);
                $self->close_path;

                my $fop = Graphics::Primitive::Operation::Fill->new(
                    preserve => 1,
                    paint => Graphics::Primitive::Paint::Solid->new(
                        color => $color,
                    )
                );
                $self->do($fop);

                my $op = Graphics::Primitive::Operation::Stroke->new;
                $op->brush($self->brush->clone);
                $op->brush->color($self->border_color);
                $self->do($op);

                $pos += $degs;
                $v++;
            }
        }
    }

    return 1;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::PolarArea

=head1 DESCRIPTION

Chart::Clicker::Renderer::PolarArea renders each series as a slice of a pie.
The values of the series determine the radius of each slice, with larger
values making the slices longer.  The 360 degrees of pie is divided equally.

=begin HTML

<p><img src="http://www.onemogin.com/clicker/chart-clicker-examples/polararea/polararea.png" width="500" height="250" alt="Pie Chart" /></p>

=end HTML

=head1 SYNOPSIS

  my $par = Chart::Clicker::Renderer::PolarArea->new;
  # Optionally set the stroke
  $par->brush->width(2);
  # and color
  $par->border_color(Graphics::Color::RGB->new(red => 1, green => 1, blue => 1));

=head1 ATTRIBUTES

=head2 border_color

Set/Get the Color to use for the border.

=head2 brush

Set/Get a Brush to be used for the pie's border.

=head1 METHODS

=head2 render

Render the series.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
