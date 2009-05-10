package Chart::Clicker::Renderer::StackedBar;
use Moose;

extends 'Chart::Clicker::Renderer';

use Graphics::Primitive::Brush;
use Graphics::Primitive::Paint::Solid;
use Graphics::Primitive::Operation::Fill;
use Graphics::Primitive::Operation::Stroke;

has '+additive' => ( default => 1 );
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
has 'opacity' => (
    is => 'rw',
    isa => 'Num',
    default => 0
);

override('prepare', sub {
    my ($self) = @_;

    super;

    my $dses = $self->clicker->get_datasets_for_context($self->context);

    foreach my $ds (@{ $dses }) {
        if(!defined($self->{KEYCOUNT})) {
            $self->{KEYCOUNT} = $ds->max_key_count;
        }
        $self->{SCOUNT} += $ds->count;
    }

    return 1;
});

override('finalize', sub {
    my ($self) = @_;

    my $clicker = $self->clicker;

    my $height = $self->height;
    my $width = $self->width;

    my $dses = $clicker->get_datasets_for_context($self->context);
    my $ctx = $clicker->get_context($dses->[0]->context);
    my $domain = $ctx->domain_axis;
    my $range = $ctx->range_axis;

    my $padding = $self->bar_padding;

    my $strokewidth = $self->brush->width;
    $padding += $strokewidth;

    $self->{BWIDTH} = int(($width - ($width * $domain->fudge_amount)
        - ($padding / 2 * $self->{KEYCOUNT})) / ($self->{KEYCOUNT}));
    $self->{HBWIDTH} = $self->{BWIDTH} / 2;

    # Fetch all the colors we'll need.  Since we build each vertical bar from
    # top to bottom, we'll need to change colors vertically.
    for (my $i = 0; $i < $self->{SCOUNT}; $i++) {
        push(@{ $self->{COLORS} }, $clicker->color_allocator->next);
    }

    my @keys = @{ $dses->[0]->get_series(0)->keys };

    # Iterate over each key...
    for (my $i = 0; $i < scalar(@keys); $i++) {

        # Get all the values from every dataset's series for each key
        my @values;
        foreach my $ds (@{ $dses }) {
            push(@values, $ds->get_series_values($i));
        }

        # Mark the x, since it's the same for each Y value
        my $x = $domain->mark($width, $keys[$i],);
        my $accum = 0;

        my $val = 0;
        for my $j (0 .. $#values) {
            $val += $values[$j];
            my $y = $range->mark($height, $val);

            $self->move_to($x - $self->{HBWIDTH}, $height - $y + $self->brush->width * 2);
            $self->rectangle($self->{BWIDTH}, $y - $accum - 1);
            # Accumulate the Y value, as it dictates how much we bump up the
            # next bar.
            $accum += $y - $accum;

            my $color = $self->{COLORS}->[$j];

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
        }
    }

    return 1;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::StackedBar

=head1 DESCRIPTION

Chart::Clicker::Renderer::StackedBar renders a dataset as stacked bars.

=head1 SYNOPSIS

  my $br = Chart::Clicker::Renderer::Bar->new({});

=head1 METHODS

=head2 bar_padding

How much padding to put around a bar.  A padding of 4 will result in 2 pixels
on each side.

=head2 brush

A stroke to use on each bar.

=head2 opacity

If true this value will be used when setting the opacity of the bar's fill.

=head2 prepare

Prepare the renderer

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
