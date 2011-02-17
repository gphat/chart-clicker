package Chart::Clicker::Renderer::Bar;
use Moose;

extends 'Chart::Clicker::Renderer';

use Graphics::Primitive::Brush;

use Graphics::Primitive::Operation::Fill;
use Graphics::Primitive::Operation::Stroke;
use Graphics::Primitive::Paint::Solid;

has 'bar_padding' => (
    is => 'rw',
    isa => 'Int',
    default => 0
);
has 'bar_width' => (
    is => 'rw',
    isa => 'Num',
    predicate => 'has_bar_width'
);
has 'brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub { Graphics::Primitive::Brush->new }
);
has 'opacity' => (
    is => 'rw',
    isa => 'Num',
    default => 1
);

override('prepare', sub {
    my $self = shift();

    super;

    my $datasets = $self->clicker->get_datasets_for_context($self->context);

    $self->{KEYCOUNT} = 0;
    foreach my $ds (@{ $datasets }) {
        $self->{SCOUNT} += $ds->count;
        if($ds->max_key_count > $self->{KEYCOUNT}) {
            $self->{KEYCOUNT} = $ds->max_key_count;
        }
    }

    return 1;
});

override('finalize', sub {
    my ($self) = @_;

    my $clicker = $self->clicker;

    my $height = $self->height;
    my $width = $self->width;

    my $dses = $clicker->get_datasets_for_context($self->context);

    my $padding = $self->bar_padding + $self->brush->width * 2;

    my $offset = 1;
    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series }) {
            # TODO if undef...
            my $ctx = $clicker->get_context($ds->context);
            my $domain = $ctx->domain_axis;
            my $range = $ctx->range_axis;

            my $owidth = $width - ($width * $domain->fudge_amount);
            my $bwidth;
            if($self->has_bar_width) {
                $bwidth = $self->bar_width;
            } else {
                $bwidth = int(($owidth / $self->{KEYCOUNT})) - $padding;
            }
            my $hbwidth = int($bwidth / 2);

            # Fudge amounts mess up the calculation of bar widths, so
            # we compensate for them here.
            my $cbwidth = $bwidth / $self->{SCOUNT};
            my $chbwidth = int($cbwidth / 2);

            my $color = $clicker->color_allocator->next;

            my $base = $range->baseline;
            my $basey;
            if(defined($base)) {
                $basey = $height - $range->mark($height, $base);
            } else {
                $basey = $height;
                $base = $range->range->lower;
            }

            my @vals = @{ $series->values };
            my @keys = @{ $series->keys };

            my $sksent = $series->key_count;
            for(0..($sksent - 1)) {

                # Skip drawing anything if the value is equal to the baseline
                next if $vals[$_] == $range->baseline;

                my $x = $domain->mark($width, $keys[$_]);
                my $y = $range->mark($height, $vals[$_]);

                if($vals[$_] >= $base) {
                    if($self->{SCOUNT} == 1) {
                        $self->move_to($x + $chbwidth, $basey);
                        $self->rectangle(
                            -int($cbwidth), -int($y - ($height - $basey))
                        );
                    } else {
                        $self->move_to(
                            $x - $hbwidth + ($offset * $cbwidth), $basey
                        );
                        $self->rectangle(
                            -int($cbwidth) + $self->brush->width, -int($y - ($height - $basey))
                        );
                    }
                } else {
                    if($self->{SCOUNT} == 1) {
                        $self->move_to($x + $chbwidth, $basey);
                        $self->rectangle(
                            -int($cbwidth), -int($y - ($height - $basey))
                        );
                    } else {
                        $self->move_to(
                            $x - $hbwidth + ($offset * $cbwidth), $basey
                        );
                        $self->rectangle(
                            -int($cbwidth) + $self->brush->width, int($height - $basey - $y)
                        );
                    }
                }
            }

            my $fillop = Graphics::Primitive::Operation::Fill->new(
                paint => Graphics::Primitive::Paint::Solid->new
            );

            my $brwidth = $self->brush->width;

            if($self->opacity < 1) {
                my $fillcolor = $color->clone;
                $fillcolor->alpha($self->opacity);
                $fillop->paint->color($fillcolor);
                # Since we're going to stroke this, we want to preserve it.
                $fillop->preserve(1) if $brwidth;
            } else {
                $fillop->paint->color($color);
            }

            $self->do($fillop);

            if(($self->opacity < 1) && ($brwidth > 0)) {
                my $strokeop = Graphics::Primitive::Operation::Stroke->new;
                $strokeop->brush($self->brush->clone);
                unless(defined($self->brush->color)) {
                    $strokeop->brush->color($color);
                }
                $self->do($strokeop);
            }

            $offset++;
        }
    }

    return 1;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Bar - Bar renderer

=head1 DESCRIPTION

Chart::Clicker::Renderer::Bar renders a dataset as bars.

=begin HTML

<p><img src="http://www.onemogin.com/clicker/chart-clicker-examples/bar/bar.png" width="500" height="250" alt="Bar Chart" /></p>

=end HTML

=head1 SYNOPSIS

  my $br = Chart::Clicker::Renderer::Bar->new();

=head1 NEGATIVE BARS

If you'd like to render both "negative and positive" bars, look at
L<Chart::Clicker::Axis>'s C<baseline> attribute.  Setting it will result in
something like this:

=begin HTML

<p><img src="http://www.onemogin.com.com/clicker/chart-clicker-examples/bar/bar-baseline.png" width="500" height="250" alt="Base (Baseline) Chart" /></p>

=end HTML

=head1 ATTRIBUTES

=head2 bar_padding

How much padding to put around a bar.  A padding of 4 will result in 2 pixels
on each side.

=head2 bar_width

Allows you to override the calculation that determines the optimal width for
bars.  Be careful using this as it can making things look terrible.  Note that
this number is divided evenly between all the values in a series when charting
multiple series.

=head2 brush

Set/Get the Brush to use around each bar.

=head2 opacity

Set/Get the alpha value to make each bar more or less opaque.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
