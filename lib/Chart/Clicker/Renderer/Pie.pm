package Chart::Clicker::Renderer::Pie;
use Moose;

extends 'Chart::Clicker::Renderer';

use Graphics::Color::RGB;
use Geometry::Primitive::Arc;
use Geometry::Primitive::Circle;
use Graphics::Primitive::Brush;
use Graphics::Primitive::Paint::Gradient::Radial;

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
has 'gradient_color' => (
    is => 'rw',
    isa => 'Graphics::Color::RGB',
    predicate => 'has_gradient_color'
);
has 'gradient_reverse' => (
    is => 'rw',
    isa	=> 'Bool',
    default => 0,
);
has 'starting_angle' => (
    is => 'rw',
    isa	=> 'Int',
    default => -90,
);

my $TO_RAD = (4 * atan2(1, 1)) / 180;

override('prepare', sub {
    my $self = shift;

    super;

    my $clicker = $self->clicker;

    my $dses = $clicker->get_datasets_for_context($self->context);
    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series }) {
            foreach my $val (@{ $series->values }) {
                $self->{ACCUM}->{refaddr($series)} += $val;
                $self->{TOTAL} += $val;
            }
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

    # Take into acount the line around the edge when working out the radius
    $radius -= $self->brush->width;

    my $height = $self->height;
    my $linewidth = 1;
    my $midx = $self->width / 2;
    my $midy = $height / 2;
    my $pos = $self->starting_angle;

    my $dses = $clicker->get_datasets_for_context($self->context);
    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series }) {

            # TODO if undef...
            my $ctx = $clicker->get_context($ds->context);
            my $domain = $ctx->domain_axis;
            my $range = $ctx->range_axis;

            my $avg = $self->{ACCUM}->{refaddr($series)} / $self->{TOTAL};
            my $degs = ($avg * 360) + $pos;

            $self->move_to($midx, $midy);
            $self->arc($radius, $degs * $TO_RAD, $pos * $TO_RAD);

            $self->close_path;

            my $color = $clicker->color_allocator->next;

            my $paint;
            if($self->has_gradient_color) {
                my $gc = $self->gradient_color;
                my $start_radius = 0;
                my $end_radius = $radius;

                if($self->gradient_reverse) {
                    $start_radius = $radius;
                    $end_radius = 0;
                }

                $paint = Graphics::Primitive::Paint::Gradient::Radial->new(
                    start => Geometry::Primitive::Circle->new(
                        origin => [ $midx, $midy ],
                        radius => $start_radius
                    ),
                    end => Geometry::Primitive::Circle->new(
                        origin => [ $midx, $midy ],
                        radius => $end_radius
                    )
                );
                $paint->add_stop(0, $color);
                $paint->add_stop(1, $color->clone(
                    red     => $color->red + ($gc->red - $color->red) * $gc->alpha,
                    green   => $color->green + ($gc->green - $color->green) * $gc->alpha,
                    blue    => $color->blue + ($gc->blue - $color->blue) * $gc->alpha,
                ));
            } else {
                $paint = Graphics::Primitive::Paint::Solid->new(
                    color => $color,
                );
            }

            my $fop = Graphics::Primitive::Operation::Fill->new(
                preserve => 1,
                paint => $paint
            );
            $self->do($fop);

            my $op = Graphics::Primitive::Operation::Stroke->new;
            $op->brush($self->brush->clone);
            $op->brush->color($self->border_color);
            $self->do($op);

            $pos = $degs;
        }
    }

    return 1;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Pie

=head1 DESCRIPTION

Chart::Clicker::Renderer::Pie renders a dataset as slices of a pie.  The keys
of like-named Series are totaled and keys are ignored.  So for a dataset like:

  my $series = Chart::Clicker::Data::Series->new(
      keys    => [ 1, 2, 3 ],
      values  => [ 1, 2, 3],
  );

  my $series2 = Chart::Clicker::Data::Series->new(
      keys    => [ 1, 2, 3],
      values  => [ 1, 1, 1 ],
  );
  
The keys are discarded and a pie chart will be drawn with $series' slice at
66% (1 + 2 + 3 = 6) and $series2's at 33% (1 + 1 + 1 = 3).

=begin HTML

<p><img src="http://www.onemogin.com/clicker/chart-clicker-examples/pie/pie.png" width="300" height="250" alt="Pie Chart" /></p>

=end HTML

=head1 SYNOPSIS

  my $pier = Chart::Clicker::Renderer::Pie->new;
  # Optionally set the stroke width
  $pier->brush->width(2);

=head1 ATTRIBUTES

=head2 border_color

Set/Get the Color to use for the border.

=head2 brush

Set/Get a Brush to be used for the pie's border.

=head2 gradient_color

If supplied, specifies a color to mix with each slice's color for use as a
radial gradient.  The best results are usually gotten from mixing with a
white or black and manipulating the alpha, like so:

  $ren->gradient_color(
    Graphics::Color::RGB->new(red => 1, green => 1, blue => 1, alpha => .3)
  );
  
The above will cause each generated color to fade toward a lighter version of
itself.  Adjust the alpha to increase or decrease the effect.

=begin HTML

<p><img src="http://www.onemogin.com/clicker/chart-clicker-examples/pie/pie-gradient.png" width="300" height="250" alt="Pie Chart" /></p>

=end HTML

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
