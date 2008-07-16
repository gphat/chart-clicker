package Chart::Clicker::Renderer::Pie;
use Moose;

extends 'Chart::Clicker::Renderer';

use Graphics::Color::RGB;
use Geometry::Primitive::Arc;
use Graphics::Primitive::Stroke;

has 'border_color' => (
    is => 'rw',
    isa => 'Graphics::Color::RGB',
    default => sub { Graphics::Color::RGB->new },
    coerce => 1
);
has 'stroke' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Stroke',
    default => sub { Graphics::Primitive::Stroke->new() }
);

my $TO_RAD = (4 * atan2(1, 1)) / 180;

override('prepare', sub {
    my $self = shift();

    super;

    my $clicker = $self->clicker;

    my $dses = $clicker->get_datasets_for_context($self->context);
    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series() }) {
            foreach my $val (@{ $series->values() }) {
                $self->{ACCUM}->{$series->name()} += $val;
                $self->{TOTAL} += $val;
            }
        }
    }

});

override('draw', sub {
    my $self = shift();

    my $clicker = $self->clicker;
    my $cr = $clicker->cairo;

    $self->{RADIUS} = $self->height();
    if($self->width() < $self->height()) {
        $self->{RADIUS} = $self->width();
    }

    $self->{RADIUS} = $self->{RADIUS} / 2;

    # Take into acount the line around the edge when working out the radius
    $self->{RADIUS} -= $self->stroke->width();

    my $height = $self->height();
    my $linewidth = 1;
    my $midx = $self->width() / 2;
    my $midy = $height / 2;
    $self->{POS} = -90;

    my $dses = $clicker->get_datasets_for_context($self->context);
    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series }) {

            # TODO if undef...
            my $ctx = $clicker->get_context($ds->context);
            my $domain = $ctx->domain_axis;
            my $range = $ctx->range_axis;

            $cr->set_line_cap($self->stroke->line_cap());
            $cr->set_line_join($self->stroke->line_join());
            $cr->set_line_width($self->stroke->width());

            my $avg = $self->{ACCUM}->{$series->name()} / $self->{TOTAL};
            my $degs = ($avg * 360) + $self->{POS};

            $cr->line_to($midx, $midy);

            $cr->arc_negative($midx, $midy, $self->{RADIUS}, $degs * $TO_RAD, $self->{POS} * $TO_RAD);
            $cr->line_to($midx, $midy);
            $cr->close_path();

            my $color = $clicker->color_allocator->next();

            $cr->set_source_rgba($color->as_array_with_alpha());
            $cr->fill_preserve();

            $cr->set_source_rgba($self->border_color->as_array_with_alpha());
            $cr->stroke();

            $self->{POS} = $degs;
        }
    }

    return 1;
});

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Pie

=head1 DESCRIPTION

Chart::Clicker::Renderer::Pie renders a dataset as slices of a pie.  The keys
of like-named Series are totaled and keys are ignored.

=head1 SYNOPSIS

  my $lr = Chart::Clicker::Renderer::Pie->new();
  # Optionally set the stroke
  $lr->options({
    stroke => Graphics::Primitive::Stroke->new({
      ...
    })
  });

=head1 OPTIONS

=over 4

=item I<stroke>

Set a Stroke object to be used for the lines.

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
