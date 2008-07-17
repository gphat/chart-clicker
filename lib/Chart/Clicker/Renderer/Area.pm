package Chart::Clicker::Renderer::Area;
use Moose;
use Cairo;

extends 'Chart::Clicker::Renderer';

use Graphics::Primitive::Stroke;

has 'fade' => (
    is => 'rw',
    isa => 'Bool',
    default => 0
);
has 'opacity' => (
    is => 'rw',
    isa => 'Num',
    default => 0
);
has 'stroke' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Stroke',
    default => sub { Graphics::Primitive::Stroke->new() }
);

override('draw', sub {
    my $self = shift();

    my $clicker = $self->clicker;
    my $cr = $clicker->cairo;

    my $height = $self->height();
    my $width = $self->width();

    my $dses = $clicker->get_datasets_for_context($self->context);
    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series }) {

            # TODO if undef...
            my $ctx = $clicker->get_context($ds->context);
            my $domain = $ctx->domain_axis;
            my $range = $ctx->range_axis;

            $cr->set_line_width($self->stroke->width());
            $cr->set_line_cap($self->stroke->line_cap());
            $cr->set_line_join($self->stroke->line_join());

            $cr->new_path();

            my $lastx; # used for completing the path
            my @vals = @{ $series->values() };
            my @keys = @{ $series->keys() };

            my $startx;

            for(0..($series->key_count() - 1)) {

                my $x = $domain->mark($keys[$_]);

                my $y = $height - $range->mark($vals[$_]);
                if($_ == 0) {
                    $startx = $x;
                    $cr->move_to($x, $y);
                } else {
                    $cr->line_to($x, $y);
                }
                $lastx = $x;
            }
            my $color = $self->clicker->color_allocator->next();
            $cr->set_source_rgba($color->as_array_with_alpha());

            my $path = $cr->copy_path();
            $cr->stroke();

            $cr->append_path($path);
            $cr->line_to($lastx, $height);
            $cr->line_to($startx, $height);
            $cr->close_path();

            if($self->opacity()) {

                my $clone = $color->clone();
                $clone->alpha($self->opacity());
                $cr->set_source_rgba($clone->as_array_with_alpha());
            } elsif($self->fade()) {

                my $patt = Cairo::LinearGradient->create(0.0, 0.0, 1.0, $height);
                $patt->add_color_stop_rgba(
                    1.0, $color->red(), $color->green(), $color->blue(),
                    $color->alpha()
                );
                $patt->add_color_stop_rgba(
                    0.0, $color->red(), $color->green(), $color->blue(), 0
                );
                $cr->set_source($patt);
            } else {

                $cr->set_source_rgba($color->as_array_with_alpha());
            }

            $cr->fill();
        }
    }

    return 1;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Area

=head1 DESCRIPTION

Chart::Clicker::Renderer::Area renders a dataset as lines.

=head1 SYNOPSIS

  my $ar = Chart::Clicker::Renderer::Area->new({
      fade => 1,
      stroke => Graphics::Primitive::Stroke->new({
          width => 2
      })
  });

=head1 ATTRIBUTES

=over 4

=item I<fade>

If true, the color of the fill will be faded from opaque at the top to
transparent at the bottom.

=item I<opacity>

If true this value will be used when setting the opacity of the fill.  This
setting may not be used with the 'fade' option.

=item I<stroke>

Allows a Stroke object to be passed that will define the Stroke used on the
series' line.

=back

=head1 METHODS

=head2 Misc. Methods

=over 4

=item I<draw>

Draw the data.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

L<Chart::Clicker::Renderer>, perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
