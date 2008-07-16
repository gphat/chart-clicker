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
        if($ds->max_key_count() > $self->{KEYCOUNT}) {
            $self->{KEYCOUNT} = $ds->max_key_count();
        }
    }

    $self->{SCOUNT} = 1;

    return 1;
});

override('draw', sub {
    my $self = shift();

    my $clicker = $self->clicker;
    my $cr = $clicker->cairo;

    my $height = $self->height();
    my $width = $self->width();

    my $dses = $clicker->get_datasets_for_context($self->context);
    my $dscount = scalar(@{ $dses });

    my $padding = $self->bar_padding + $self->stroke->width;

    if(!$self->{BWIDTH}) {
        $self->{BWIDTH} = int(($width / $self->{KEYCOUNT}) / $dscount / 2);
    }

    if(!$self->{XOFFSET}) {
        $self->{XOFFSET} = int((($self->{BWIDTH} + $padding) * $dscount) / 2);
    }

    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series }) {

            # TODO if undef...
            my $ctx = $clicker->get_context($ds->context);
            my $domain = $ctx->domain_axis;
            my $range = $ctx->range_axis;

            my @vals = @{ $series->values() };
            my @keys = @{ $series->keys() };

            my $color = $clicker->color_allocator->next();

            # Calculate the bar width we can use to fit all the datasets.

            my $base = $range->baseline();
            my $basey;
            if(defined($base)) {
                $basey = $height - $range->mark($base);
            } else {
                $basey = $height;
                $base = $range->range->lower();
            }

            my $sksent = $series->key_count() - 1;
            for(0..$sksent) {
                # Add the series_count times the width to so that each bar
                # gets rendered with it's partner in the other series.
                my $x = $domain->mark($keys[$_]) + ($self->{'SCOUNT'} * $self->{'BWIDTH'});
                my $y = $range->mark($vals[$_]);

                if($vals[$_] >= $base) {
                    $cr->rectangle(
                        ($x + $padding) - $self->{'XOFFSET'}, $basey,
                        - ($self->{'BWIDTH'} - $padding), -int($y - ($height - $basey)),
                    );
                } else {
                    $cr->rectangle(
                        ($x + $padding) - $self->{'XOFFSET'}, $basey,
                        - ($self->{'BWIDTH'} - $padding), int($height - $basey - $y),
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

            $self->{'SCOUNT'}++;
        }
    }

    return 1;
});

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
