package Chart::Clicker::Renderer::StackedBar;
use Moose;

extends 'Chart::Clicker::Renderer';

has '+additive' => ( default => 1 );
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

    my $dses = $self->clicker->get_datasets_for_context($self->context);

    # Find the largest number of keys.  Should we really do this?  We could
    # probably just take the first since stacked bars doesn't work if the data
    # doesn't match up.
    foreach my $ds (@{ $dses }) {
        if(!defined($self->{KEYCOUNT})) {
            $self->{KEYCOUNT} = $ds->max_key_count();
        }
        $self->{SCOUNT} += $ds->count;
    }

    return 1;
});

override('draw', sub {
    my $self = shift();

    my $clicker = $self->clicker;
    my $cr = $clicker->cairo;

    my $height = $self->height;
    my $width = $self->width;

    my $dses = $clicker->get_datasets_for_context($self->context);
    my $ctx = $clicker->get_context($dses->[0]->context);
    my $domain = $ctx->domain_axis;
    my $range = $ctx->range_axis;

    my $padding = $self->bar_padding();

    my $strokewidth = $self->stroke->width();
    $padding += $strokewidth;

    $self->{BWIDTH} = int($width / ($self->{KEYCOUNT}));
    $self->{HBWIDTH} = $self->{BWIDTH} / 2;

    # Fetch all the colors we'll need.  Since we build each vertical bar from
    # top to bottom, we'll need to change colors vertically.
    for (my $i = 0; $i < $self->{SCOUNT}; $i++) {
        push(@{ $self->{COLORS} }, $clicker->color_allocator->next);
    }

    my @keys = @{ $dses->[0]->get_series(0)->keys };

    # Iterate over each key...
    for (my $i = 0; $i < $self->{KEYCOUNT}; $i++) {

        # Get all the values from every dataset's series for each key
        my @values;
        foreach my $ds (@{ $dses }) {
            push(@values, $ds->get_series_values($i));
        }

        # Mark the x, since it's the same for each Y value
        my $x = $domain->mark($keys[$i]);
        my $accum = 0;

        for(my $j = 0; $j < scalar(@values); $j++) {
            my $y = $range->mark($values[$j]);

            $cr->rectangle(
                $x - $self->{HBWIDTH}, $height - $y - $accum,
                $self->{BWIDTH}, $y
            );
            # Accumulate the Y value, as it dictates how much we bump up the
            # next bar.
            $accum += $y;

            my $color = $self->{COLORS}->[$j];

            my $fillcolor;
            if($self->opacity()) {
                $fillcolor = $color->clone();
                $fillcolor->alpha($self->opacity());
            } else {
                $fillcolor = $color;
            }

            $cr->set_source_rgba($fillcolor->as_array_with_alpha());
            $cr->fill_preserve();

            $cr->set_line_width($strokewidth);
            $cr->set_line_cap($self->stroke->line_cap());
            $cr->set_line_join($self->stroke->line_join());

            $cr->set_source_rgba($color->as_array_with_alpha());
            $cr->stroke();
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

=head1 ATTRIBUTES

=over 4

=item I<opacity>

If true this value will be used when setting the opacity of the bar's fill.

=item I<padding>

How much padding to put around a bar.  A padding of 4 will result in 2 pixels
on each side.

=item I<stroke>

A stroke to use on each bar.

=back

=head1 METHODS

=head2 Instance Methods

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
