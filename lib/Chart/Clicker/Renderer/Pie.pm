package Chart::Clicker::Renderer::Pie;
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
    coerce => 1
);
has 'brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub { Graphics::Primitive::Brush->new }
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

override('pack', sub {
    my $self = shift;

    my $clicker = $self->clicker;

    $self->{RADIUS} = $self->height;
    if($self->width < $self->height) {
        $self->{RADIUS} = $self->width;
    }

    $self->{RADIUS} = $self->{RADIUS} / 2;

    # Take into acount the line around the edge when working out the radius
    $self->{RADIUS} -= $self->brush->width;

    my $height = $self->height;
    my $linewidth = 1;
    my $midx = $self->width / 2;
    my $midy = $height / 2;
    $self->{POS} = -90;

    my $dses = $clicker->get_datasets_for_context($self->context);
    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series }) {

            # TODO if undef...
            my $ctx = $clicker->get_context($ds->context);
            my $domain = $ctx->domain_axis;
            my $range = $ctx->range_axis;

            my $avg = $self->{ACCUM}->{refaddr($series)} / $self->{TOTAL};
            my $degs = ($avg * 360) + $self->{POS};

            $self->move_to($midx, $midy);
            $self->arc($self->{RADIUS}, $degs * $TO_RAD, $self->{POS} * $TO_RAD);

            $self->close_path;

            my $color = $clicker->color_allocator->next;

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

            $self->{POS} = $degs;
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

=head1 SYNOPSIS

  my $lr = Chart::Clicker::Renderer::Pie->new;
  # Optionally set the stroke
  $lr->options({
    brush => Graphics::Primitive::Brush->new({
      ...
    })
  });

=head1 OPTIONS

=over 4

=item I<brush>

Set a brush object to be used for the lines.

=back

=head1 METHODS

=head2 Instance Methods

=over 4

=item I<render>

Render the series.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
