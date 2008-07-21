package Chart::Clicker::Renderer::Bar;
use Moose;

extends 'Chart::Clicker::Renderer';

use Graphics::Primitive::Stroke;

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
has 'stroke' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Stroke',
    default => sub { Graphics::Primitive::Stroke->new() }
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

override('draw', sub {
    my $self = shift();

    my $clicker = $self->clicker;
    my $cr = $clicker->cairo;

    my $height = $self->height();
    my $width = $self->width();

    my $dses = $clicker->get_datasets_for_context($self->context);

    my $padding = $self->bar_padding + $self->stroke->width;

    my $bwidth = int(($width / $self->{KEYCOUNT})) - $self->stroke->width;
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

            my $color = $clicker->color_allocator->next();

            my $base = $range->baseline();
            my $basey;
            if(defined($base)) {
                $basey = $height - $range->mark($base);
            } else {
                $basey = $height;
                $base = $range->range->lower;
            }

            my @vals = @{ $series->values() };
            my @keys = @{ $series->keys() };

            my $sksent = $series->key_count;
            for(0..($sksent - 1)) {
                # I don't remember why all this math is here, but it works
                # perfectly now. ;)
                my $x = $domain->mark($keys[$_]);
                my $y = $range->mark($vals[$_]);

                if($vals[$_] >= $base) {
                    if($self->{SCOUNT} == 1) {
                        $cr->rectangle(
                            $x + $chbwidth , $basey,
                            -int($cbwidth), -int($y - ($height - $basey))
                        );
                    } else {
                        $cr->rectangle(
                            $x - $hbwidth + ($offset * $cbwidth), $basey,
                            -int($cbwidth), -int($y - ($height - $basey))
                        );
                    }
                } else {
                    $cr->rectangle(
                        $x - $hbwidth + ($offset * $cbwidth), $basey,
                        -int($cbwidth), int($height - $basey - $y)
                    );
                }
            }

            my $fillcolor;
            if($self->opacity()) {
                $fillcolor = $color->clone();
                $fillcolor->alpha($self->opacity());
            } else {
                $fillcolor = $color;
            }

            $cr->set_source_rgba($fillcolor->as_array_with_alpha());
            $cr->fill_preserve();


            $cr->set_line_width($self->stroke->width());
            $cr->set_line_cap($self->stroke->line_cap());
            $cr->set_line_join($self->stroke->line_join());

            $cr->set_source_rgba($color->as_array_with_alpha());
            $cr->stroke();

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

=item I<draw>

Draw the data!

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
