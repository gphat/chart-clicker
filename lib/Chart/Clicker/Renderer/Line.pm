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
    my %accum;
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

                my $key = $keys[$_];

                my $x = $domain->mark($width, $key);
                next unless defined($x);
                my $ymark = $range->mark($height, $vals[$_]);
                next unless defined($ymark);

                if($self->additive) {
                    if(exists($accum{$key})) {
                        $accum{$key} += $ymark;
                        $ymark = $accum{$key};
                    } else {
                        $accum{$key} = $ymark;
                    }
                }

                my $y = $height - $ymark;

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

            if(defined($self->shape)) {
                for(0..$kcount) {
                    my $key = $keys[$_];
                    my $x = $domain->mark($width, $key);
                    next unless defined($x);
                    my $ymark = $range->mark($height, $vals[$_]);
                    next unless defined($ymark);

                    if($self->additive) {
                        if(exists($accum{$key})) {
                            $ymark = $accum{$key};
                        } else {
                            $accum{$key} = $ymark;
                        }
                    }

                    my $y = $height - $ymark;

                    $self->move_to($x, $y);
                    $self->draw_point($x, $y, $series, $vals[$_]);
                }

                # Fill the shape
                my $op2 = Graphics::Primitive::Operation::Fill->new(
                    paint => Graphics::Primitive::Paint::Solid->new(
                        color => $color
                    )
                );
                if(defined($self->shape_brush)) {
                    $op2->preserve(1);
                }
                $self->do($op2);

                # Optionally stroke the shape
                if(defined($self->shape_brush)) {
                    my $op3 = Graphics::Primitive::Operation::Stroke->new;
                    $op3->brush($self->shape_brush->clone);
                    $self->do($op3);
                }
            }
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

Chart::Clicker::Renderer::Line - Line renderer

=head1 DESCRIPTION

Chart::Clicker::Renderer::Line renders a dataset as lines.

=begin HTML

<p><img src="http://www.onemogin.com/clicker/chart-clicker-examples/line/line.png" width="500" height="250" alt="Line Chart" /></p>

=end HTML

=head1 SYNOPSIS

  my $lr = Chart::Clicker::Renderer::Line->new(
    brush => Graphics::Primitive::Brush->new({
      ...
    })
  });

=head1 ATTRIBUTES

=head2 additive

If true, the lines are drawn "stacked", each key accumulates based on those
drawn below it.

=head2 brush

Set/Get a Brush to be used for the lines.

=head2 draw_point

Called for each point encountered on the line.

=head2 finalize

Draw the actual line chart

=head2 shape

Set a shape object to draw at each of the data points.  Adding a shape results
in:

=begin HTML

<p><img src="http://www.onemogin.com/clicker/chart-clicker-examples/line/line-shapes.png" width="500" height="250" alt="Line + Shape Chart" /></p>

=end HTML

=head2 shape_brush

Set/Get the Brush to be used on the shapes at each point.  If no shape_brush
is provided, then the shapes will be filled.  The brush allows you to draw a
"halo" around each shape.  This sometimes help to separate the points from the
lines and make them more distinct.

=begin HTML

<p><img src="http://www.onemogin.com/clicker/chart-clicker-examples/line/line-shapes-brushed.png" width="500" height="250" alt="Line + Shape (Brushed) Chart" /></p>

=end HTML

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
