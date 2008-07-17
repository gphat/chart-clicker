package Chart::Clicker::Renderer::Line;
use Moose;

extends 'Chart::Clicker::Renderer';

use Graphics::Primitive::Stroke;

has 'shape' => (
    is => 'rw',
    isa => 'Chart::Clicker::Shape'
);
has 'shape_stroke' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Stroke',
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

            $cr->new_path();

            my $color = $clicker->color_allocator->next();
            $cr->set_source_rgba($color->as_array_with_alpha());

            my @vals = @{ $series->values() };
            my @keys = @{ $series->keys() };

            my $kcount = $series->key_count() - 1;

            for(0..$kcount) {
                my $x = $domain->mark($keys[$_]);
                my $y = $height - $range->mark($vals[$_]);
                if($_ == 0) {
                    $cr->move_to($x, $y);
                } else {
                    $cr->line_to($x, $y);
                }
            }
            $cr->stroke();

            if(defined($self->shape())) {
                for(0..$kcount) {

                    my $x = $domain->mark($keys[$_]);
                    my $y = $height - $range->mark($vals[$_]);
                    $self->shape->create_path($cr, $x, $y);

                    if($self->shape_stroke()) {
                        $cr->set_line_cap($self->shape_stroke->line_cap());
                        $cr->set_line_join($self->shape_stroke->line_join());
                        $cr->set_line_width($self->shape_stroke->width());
                        $cr->stroke();
                    } else {
                        $cr->fill();
                    }
                }
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

Chart::Clicker::Renderer::Line

=head1 DESCRIPTION

Chart::Clicker::Renderer::Line renders a dataset as lines.

=head1 SYNOPSIS

  my $lr = Chart::Clicker::Renderer::Line->new(
    stroke => Graphics::Primitive::Stroke->new({
      ...
    })
  });

=head1 ATTRIBUTES

=over 4

=item I<shape>

Set a shape object to draw at each of the data points.

=item I<shape_stroke>

Define the stroke to be used on the shapes at each point.  If no shape_stroke
is provided, then the shapes will be billed.

=item I<stroke>

Set a Stroke object to be used for the lines.

=back

=head1 METHODS

=head2 Misc Methods

=over 4

=item I<draw>

Draw it!

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
