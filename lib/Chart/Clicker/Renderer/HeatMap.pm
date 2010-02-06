package Chart::Clicker::Renderer::HeatMap;
use Moose;

extends 'Chart::Clicker::Renderer';

use Geometry::Primitive::Point;
use Graphics::Color::RGB;
use Graphics::Primitive::Brush;
use Graphics::Primitive::Operation::Stroke;
use List::Util qw(min max);

has 'color_stops' => (
    is => 'rw',
    isa => 'ArrayRef[Graphics::Color::RGB]',
    default => [
        Graphics::Color::RGB->new(red => 0, green => 1, blue => 0),
        Graphics::Color::RGB->new(red => 1, green => 0, blue => 0)
    ]
);

has 'gradient' => (
    is => 'rw',
    isa => 'ArrayRef',
    lazy_build => 1
);

has 'min_size' => (
    is => 'rw',
    isa => 'Num',
    predicate => 'has_min_size'
);

has 'max_size' => (
    is => 'rw',
    isa => 'Num',
    predicate => 'has_max_size'
);

has 'range' => (
    is => 'rw',
    isa => 'Num',
    lazy => 1,
    default => sub {
        my $self = shift;
        return $self->max - $self->min
    }
);

sub _build_gradient {
    my ($self) = @_;
}

override('prepare', sub {
    my $self = shift;

    super;

    # No reason to look at this if we've already had all this set...
    return if $self->has_min_size && $self->has_max_size;

    my $clicker = $self->clicker;

    my @min = ();
    my @max = ();
    my $dses = $clicker->get_datasets_for_context($self->context);
    die 'HeatMap may only have one dataset!' unless scalar(@{ $dses }) == 1;

    die 'HeatMap may only have one series!' unless scalar(@{ $dses[0]->series }) == 1;

    $self->max_size($series->max_size);
    $self->min_size($series->min_size);
});

override('finalize', {
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
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::HeatMap

=head1 DESCRIPTION

Chart::Clicker::Renderer::HeatMap renders a map of values represented by color.

=begin HTML

<p><img src="http://www.onemogin.com/clicker/chart-clicker-examples/heatmap/heatmap.png" width="500" height="250" alt="Heat Map" /></p>

=end HTML

=head1 SYNOPSIS

  my $lr = Chart::Clicker::Renderer::Line->new(
    brush => Graphics::Primitive::Brush->new({
      ...
    })
  });

=head1 ATTRIBUTES

=head2 color_stops

An arrayref of colors that represent the various "stops" on a map. The default
value is green and red, represented as:

  [
    Graphics::Color::RGB->new(red => 0, green => 1, blue => 0),
    Graphics::Color::RGB->new(red => 1, green => 0, blue => 0)
  ]

When sizes are plotted in the map, the color is chosen by generating a gradient
between the colors specified in C<color_stops>.

=head1 METHODS

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
