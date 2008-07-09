package Chart::Clicker::Renderer::Bar;
use Moose;

extends 'Chart::Clicker::Renderer';

use Graphics::Primitive::Stroke;

has 'opacity' => (
    is => 'rw',
    isa => 'Num',
    default => 0
);
has 'padding' => (
    is => 'rw',
    isa => 'Int',
    default => 0
);
has 'stroke' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Stroke',
    default => sub { Graphics::Primitive::Stroke->new() }
);

sub prepare {
    my $self = shift();

    $self->SUPER::prepare(@_);

    my $clicker = shift();
    my $idim = shift();
    my $datasets = shift();

    foreach my $ds (@{ $datasets }) {
        if(!defined($self->{'KEYCOUNT'})) {
            $self->{'KEYCOUNT'} = $ds->max_key_count();
        } else {
            if($self->{'KEYCOUNT'} < $ds->max_key_count()) {
                $self->{'KEYCOUNT'} = $ds->max_key_count();
            }
        }
    }

    $self->{'SCOUNT'} = 1;

    return 1;
}

sub draw {
    my $self = shift();
    my $clicker = shift();
    my $cr = shift();
    my $series = shift();
    my $domain = shift();
    my $range = shift();

    my $height = $self->height();
    my $width = $self->width();

    my @vals = @{ $series->values() };
    my @keys = @{ $series->keys() };

    my $color = $clicker->color_allocator->next();

    my $padding = $self->padding();

    $padding += $self->stroke->width();

    # Calculate the bar width we can use to fit all the datasets.
    if(!$self->{'BWIDTH'}) {
        $self->{'BWIDTH'} = int(($width / scalar(@vals)) / $self->dataset_count() / 2);
    }

    if(!$self->{'XOFFSET'}) {
        $self->{'XOFFSET'} = int((($self->{'BWIDTH'} + $padding) * $self->dataset_count()) / 2);
    }

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

    $cr->set_source_rgba($fillcolor->rgba());
    $cr->fill_preserve();


    $cr->set_line_width($self->stroke->width());
    $cr->set_line_cap($self->stroke->line_cap());
    $cr->set_line_join($self->stroke->line_join());

    $cr->set_source_rgba($color->rgba());
    $cr->stroke();

    $self->{'SCOUNT'}++;

    return 1;
}

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

=item opacity

If true this value will be used when setting the opacity of the bar's fill.

=item padding

How much padding to put around a bar.  A padding of 4 will result in 2 pixels
on each side.

=item stroke

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
