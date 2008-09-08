package Chart::Clicker::Renderer::Bar;
use Moose;

extends 'Chart::Clicker::Renderer';

use Graphics::Primitive::Brush;

use Graphics::Primitive::Operation::Fill;
use Graphics::Primitive::Operation::Stroke;
use Graphics::Primitive::Paint::Solid;

has 'opacity' => (
    is => 'rw',
    isa => 'Num',
    default => 0
);
has 'bar_padding' => (
    is => 'rw',
    isa => 'Int',
    default => 0
);
has 'brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub { Graphics::Primitive::Brush->new }
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
    my $self = shift();

    my $clicker = $self->clicker;

    my $height = $self->height;
    my $width = $self->width;

    my $dses = $clicker->get_datasets_for_context($self->context);

    my $padding = $self->bar_padding + $self->brush->width;

    my $bwidth = int(($width / $self->{KEYCOUNT})) - $self->brush->width;
    my $hbwidth = int($bwidth / 2);

    my $offset = 1;
    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series }) {
            # TODO if undef...
            my $ctx = $clicker->get_context($ds->context);
            my $domain = $ctx->domain_axis;
            my $range = $ctx->range_axis;

            # Fudge amounts change mess up the calculation of bar widths, so
            # we compensate for them here.
            my $cbwidth = ($bwidth - ($bwidth * $domain->fudge_amount)) / $self->{SCOUNT};
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
                my $x = $domain->mark($width, $keys[$_]);
                my $y = $range->mark($height, $vals[$_]);

                if($vals[$_] >= $base) {
                    if($self->{SCOUNT} == 1) {
                        $self->move_to($x + $chbwidth, $basey);
                        $self->rectangle(
                        #     $x + $chbwidth , $basey,
                            -int($cbwidth), -int($y - ($height - $basey))
                        );
                    } else {
                        $self->move_to(
                            $x - $hbwidth + ($offset * $cbwidth), $basey
                        );
                        $self->rectangle(
                            -int($cbwidth), -int($y - ($height - $basey))
                        );
                    }
                } else {
                    $self->move_to(
                        $x - $hbwidth + ($offset * $cbwidth), $basey
                    );
                    $self->rectangle(
                        -int($cbwidth), int($height - $basey - $y)
                    );
                }
            }

            my $fillop = Graphics::Primitive::Operation::Fill->new(
                paint => Graphics::Primitive::Paint::Solid->new
            );

            if($self->opacity) {
                my $fillcolor = $color->clone;
                $fillcolor->alpha($self->opacity);
                $fillop->paint->color($fillcolor);
                # Since we're going to stroke this, we want to preserve it.
                $fillop->preserve(1);
            } else {
                $fillop->paint->color($color);
            }

            $self->do($fillop);

            if($self->opacity) {
                my $strokeop = Graphics::Primitive::Operation::Stroke->new;
                $strokeop->brush->color($color);
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

Chart::Clicker::Renderer::Bar

=head1 DESCRIPTION

Chart::Clicker::Renderer::Bar renders a dataset as bars.

=head1 SYNOPSIS

  my $br = Chart::Clicker::Renderer::Bar->new();

=head1 ATTRIBUTES

=over 4

=item I<opacity>

If true this value will be used when setting the opacity of the bar's fill.

=item I<bar_padding>

How much padding to put around a bar.  A padding of 4 will result in 2 pixels
on each side.

=item I<stroke>

A stroke to use on each bar.

=back

=head1 METHODS

=head2 Misc. Methods

=over 4

=item I<prepare>

Prepare the renderer

=item I<pack>

Draw the data!

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
