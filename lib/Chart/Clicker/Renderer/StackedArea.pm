package Chart::Clicker::Renderer::StackedArea;
use Moose;

extends 'Chart::Clicker::Renderer::Area';

use Graphics::Primitive::Brush;
use Graphics::Primitive::Path;
use Graphics::Primitive::Operation::Fill;
use Graphics::Primitive::Operation::Stroke;
use Graphics::Primitive::Paint::Gradient::Linear;
use Graphics::Primitive::Paint::Solid;

has '+additive' => ( default => sub { 1 } );

override('finalize', sub {
    my ($self) = @_;

    my $height = $self->height;
    my $width = $self->width;
    my $clicker = $self->clicker;

    my %accum;

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

            my $biggest;
            my @replays;
            for(0..($series->key_count - 1)) {

                my $key = $keys[$_];
                my $x = $domain->mark($width, $key);
                next unless defined($x);
                my $val = $vals[$_];

                if(exists($accum{$key})) {
                    # Store the previous value
                    push(@replays, [ $x, $accum{$key}]);
                    # Add this value to the accumulator, then replace
                    # it's value with the total
                    $val = $accum{$key} += $val;
                } else {
                    push(@replays, [ $x, 0 ]);
                    $accum{$key} = $val;
                }

                my $ymark = $range->mark($height, $val);
                next unless defined($ymark);
                my $y = $height - $ymark;

                if(defined($biggest)) {
                    $biggest = $y if $y > $biggest;
                } else {
                    $biggest = $y;
                }

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

            while(my $pt = pop(@replays)) {
                $self->line_to($pt->[0], $height - $range->mark($height, $pt->[1]));
            }
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
                        end => Geometry::Primitive::Point->new(x => 1, y => $biggest),
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

Chart::Clicker::Renderer::StackedArea - Stacked Area renderer

=head1 DESCRIPTION

Chart::Clicker::Renderer::StackedArea renders a dataset as line-like
polygons stacked atop one another.

=begin HTML

<p><img src="http://www.onemogin.com/clicker/chart-clicker-examples/area/stacked-area.png" width="500" height="250" alt="Stacked Area Chart" /></p>

=end HTML

=head1 SYNOPSIS

  my $ar = Chart::Clicker::Renderer::StackedArea->new({
      fade => 1,
      brush => Graphics::Primitive::Brush->new({
          width => 2
      })
  });

=head1 ATTRIBUTES

=head2 brush

Set/Get the brush that informs the line surrounding the area renders
individual segments.

=head2 fade

Set/Get the fade flag, which turns on or off a gradient in the area renderer.

=head2 opacity

Set the alpha value for the renderer, which makes things more or less opaque.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

L<Chart::Clicker::Renderer>, perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
