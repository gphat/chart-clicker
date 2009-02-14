package Chart::Clicker::Renderer::Line;
use Moose;

extends 'Chart::Clicker::Renderer';

use Geometry::Primitive::Point;
use Graphics::Primitive::Brush;
use Graphics::Primitive::Operation::Stroke;

has 'brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub { Graphics::Primitive::Brush->new(width => 2) }
);
has 'shape' => (
    is => 'rw',
    isa => 'Geometry::Primitive::Shape',
);
has 'shape_brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
);
# TODO Readd shapes

sub finalize {
    my ($self) = @_;

    my $width = $self->width;
    my $height = $self->height;

    my $clicker = $self->clicker;

    my $dses = $clicker->get_datasets_for_context($self->context);
    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series }) {

            # TODO if undef...
            my $ctx = $clicker->get_context($ds->context);
            my $domain = $ctx->domain_axis;
            my $range = $ctx->range_axis;

            my $color = $clicker->color_allocator->next;

            my @vals = @{ $series->values };
            my @keys = @{ $series->keys };

            my $kcount = $series->key_count - 1;

            for(0..$kcount) {
                my $x = $domain->mark($width, $keys[$_]);
                my $y = $height - $range->mark($height, $vals[$_]);
                if($_ == 0) {
                    $self->move_to($x, $y);
                } else {
                    $self->line_to($x, $y);
                }
            }
            my $op = Graphics::Primitive::Operation::Stroke->new;
            $op->brush($self->brush->clone);
            $op->brush->color($color);
            $self->do($op);

            for(0..$kcount) {
                my $x = $domain->mark($width, $keys[$_]);
                my $y = $height - $range->mark($height, $vals[$_]);

                $self->move_to($x, $y);
                if(defined($self->shape)) {
                    $self->draw_point($x, $y, $series, $vals[$_]);
                }
            }
            my $op2 = Graphics::Primitive::Operation::Stroke->new;
            $op2->brush($self->brush->clone);
            $op2->brush->color($color);
            $self->do($op2);
        }
    }

    return 1;
}

sub draw_point {
    my ($self, $x, $y, $series, $count) = @_;

    my $shape = $self->shape->clone;
    $shape->origin(Geometry::Primitive::Point->new(x => $x, y => $y));
    $self->path->add_primitive($shape);
}

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
    brush => Graphics::Primitive::Brush->new({
      ...
    })
  });

=head1 METHODS

=head2 shape

Set a shape object to draw at each of the data points.

=head2 shape_brush

Set/Get the Brush to be used on the shapes at each point.  If no shape_brush
is provided, then the shapes will be filled.

=head2 brush

Set/Get a Brush to be used for the lines.

=head2 draw_point

Called for each point encountered on the line.

=head2 finalize

Draw the actual line chart

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
