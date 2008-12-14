package Chart::Clicker::Renderer::Area;
use Moose;

extends 'Chart::Clicker::Renderer';

use Graphics::Primitive::Brush;
use Graphics::Primitive::Path;
use Graphics::Primitive::Operation::Fill;
use Graphics::Primitive::Operation::Stroke;
use Graphics::Primitive::Paint::Gradient::Linear;
use Graphics::Primitive::Paint::Solid;

has 'brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub { Graphics::Primitive::Brush->new }
);
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

override('finalize', sub {
    my ($self) = @_;

    my $height = $self->height;
    my $width = $self->width;
    my $clicker = $self->clicker;

    my $dses = $clicker->get_datasets_for_context($self->context);
    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series }) {

            # TODO if undef...
            my $ctx = $clicker->get_context($ds->context);
            my $domain = $ctx->domain_axis;
            my $range = $ctx->range_axis;

            my $lastx; # used for completing the path
            my @vals = @{ $series->values };
            my @keys = @{ $series->keys };

            my $startx;

            for(0..($series->key_count - 1)) {

                my $x = $domain->mark($width, $keys[$_]);

                my $y = $height - $range->mark($height, $vals[$_]);
                if($_ == 0) {
                    $startx = $x;
                    $self->move_to($x, $y);
                } else {
                    $self->line_to($x, $y);
                }
                $lastx = $x;
            }
            my $color = $self->clicker->color_allocator->next;

            my $op = Graphics::Primitive::Operation::Stroke->new;
            $op->preserve(1);
            $op->brush($self->brush->clone);
            $op->brush->color($color);

            $self->do($op);

            $self->line_to($lastx, $height);
            $self->line_to($startx, $height);
            $self->close_path;

            my $paint;
            if($self->opacity) {

                my $clone = $color->clone;
                $clone->alpha($self->opacity);
                $paint = Graphics::Primitive::Paint::Solid->new(
                    color => $clone
                );
            } elsif($self->fade) {

                my $clone = $color->clone;
                $clone->alpha($self->opacity);

                $paint = Graphics::Primitive::Paint::Gradient::Linear->new(
                    line => Geometry::Primitive::Line->new(
                        start => Geometry::Primitive::Point->new(x => 0, y => 0),
                        end => Geometry::Primitive::Point->new(x => 1, y => $height),
                    ),
                    style => 'linear'
                );
                $paint->add_stop(1.0, $color);
                $paint->add_stop(0, $clone);
            } else {

                $paint = Graphics::Primitive::Paint::Solid->new(
                    color => $color->clone
                );
            }
            my $fillop = Graphics::Primitive::Operation::Fill->new(
                paint => $paint
            );

            $self->do($fillop);
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
      brush => Graphics::Primitive::Brush->new({
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

=item I<pack>

Draw the data.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

L<Chart::Clicker::Renderer>, perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
