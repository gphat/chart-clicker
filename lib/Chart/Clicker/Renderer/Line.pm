package Chart::Clicker::Renderer::Line;
use Moose;

# ABSTRACT: Line renderer

extends 'Chart::Clicker::Renderer';

use Geometry::Primitive::Point;
use Graphics::Primitive::Brush;
use Graphics::Primitive::Operation::Stroke;
use Geometry::Primitive::Circle;

#number of defined points we must have around another point
#to render a line instead of a scatter
#
use constant MIN_DEFINED_SURROUNDING_POINTS => 5;

=head1 DESCRIPTION

Chart::Clicker::Renderer::Line renders a dataset as lines.

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/line.png" width="500" height="250" alt="Line Chart" /></p>

=end HTML

=head1 SYNOPSIS

  my $lr = Chart::Clicker::Renderer::Line->new(
    brush => Graphics::Primitive::Brush->new({
      #...
    })
  );

=attr additive

If true, the lines are drawn "stacked", each key accumulates based on those
drawn below it.

=attr brush

Set/Get a L<brush|Graphics::Primitive::Brush> to be used for the lines.

=cut

has 'brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub { Graphics::Primitive::Brush->new(width => 2) }
);

=attr shape

Set a L<shape|Geometry::Primitive::Shape> object to draw at each of the data points.  Adding a shape results
in:

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/line-shapes.png" width="500" height="250" alt="Line + Shape Chart" /></p>

=end HTML

=cut

has 'shape' => (
    is => 'rw',
    isa => 'Geometry::Primitive::Shape',
);

=attr shape_brush

Set/Get the L<brush|Graphics::Primitive::Brush> to be used on the shapes at
each point.  If no shape_brush is provided, then the shapes will be filled.
The brush allows you to draw a "halo" around each shape.  This sometimes help
to separate the points from the lines and make them more distinct.

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/line-shapes-brushed.png" width="500" height="250" alt="Line + Shape (Brushed) Chart" /></p>

=end HTML

=cut

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

            my $skip = 0;
            my $previous_x = -1;
            my $previous_y = -1;
            my $min_y_delta_on_same_x = $height / 100;

            for(0..$kcount) {

                my $key = $keys[$_];

                my $x = $domain->mark($width, $key);
                next unless defined($x);
                $skip = 1 unless defined $vals[$_];
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
                if( $_ == 0 || $skip ) {
                    my $lineop = Graphics::Primitive::Operation::Stroke->new(
                        brush => $self->brush->clone
                    );
                    $lineop->brush->color($color);
                    $self->do($lineop);
                    $self->move_to($x, $y);
                    my $start_new_line = 1;
                    foreach my $i ($_..($_ + MIN_DEFINED_SURROUNDING_POINTS)) {
                        if ($i > 0 && $i < @vals && !defined($vals[$i])) {
                            $start_new_line = 0;
                        }
                    }
                    if ($start_new_line){
                        $skip = 0;
                    }
                    else {
                        my $shape = Geometry::Primitive::Circle->new(radius => 3);
                        $shape->origin(Geometry::Primitive::Point->new(x => $x, y => $y));
                        $self->path->add_primitive($shape);
                        my $fill = Graphics::Primitive::Operation::Fill->new(
                            paint => Graphics::Primitive::Paint::Solid->new(
                                color => $color
                            )
                        );
                        $self->do($fill);
                    }
                }
                else {
                    # when in fast mode, we plot only if we moved by more than
                    # 1 of a pixel on the X axis or we moved by more than 1%
                    # of the size of the Y axis.
                    if( $clicker->plot_mode ne 'fast' ||
                        $x - $previous_x > 1 ||
                        abs($y - $previous_y) > $min_y_delta_on_same_x
                      )
                    {
                        $self->line_to($x, $y);
                        $previous_x = $x;
                        $previous_y = $y;
                    }
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

=method draw_point

Called for each point encountered on the line.

=cut

sub draw_point {
    my ($self, $x, $y, $series, $count) = @_;

    my $shape = $self->shape->clone;
    $shape->origin(Geometry::Primitive::Point->new(x => $x, y => $y));
    $self->path->add_primitive($shape);
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
