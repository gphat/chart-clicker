package Chart::Clicker::Axis::DivisionType::LinearRounded;

use Moose::Role;
with qw{Chart::Clicker::Axis::DivisionType};

# Positive only
has 'tick_slop' => (
    is      => 'rw',
    isa     => 'Num',
    default => 0.1,
    documentation =>
        q{Percent of a tick unit above or below graphed which we allow inserting an additional tick. Whitespace allowance above or below.}
);

# Take the rough tick size which is the smallest possible 'round' scale
# and use other sub-divisors to aim for the number of ticks specified.
sub best_tick_size {
    my ($self) = @_;

    my $minimum_target_ticks = $self->ticks;
    $minimum_target_ticks = 1 if ( $minimum_target_ticks < 1 );

    my $equal_tick_size = $self->range->span / ($minimum_target_ticks);

    # Provide a nice round divisor which is within an order of
    # magnitude of the actual wanted tick size. We adjust
    # this value using hand specified sub-divider values
    #
    # Small ranges (below 1) require an additional digit
    my $digits = int( log( abs($equal_tick_size) ) / log(10) );
    $digits-- if ( abs( $self->range->span ) < 1 );
    my $scale_size = 10**$digits;

    # Take the largest divider (smallest number of ticks) which will provide
    # a nice looking result. The below dividers were selected arbitrarily to
    # create visually pleasing numbers for an axis.
    #
    # The number of ticks will be equal to or larger than the requested number
    # of ticks. Never smaller. The worst case is the 1 to 2 range which may
    # provide nearly double (2N - 1) the number of requested ticks.
ADJUSTSCALE:
    for my $scale_divider ( 25, 20, 10, 5, 4, 2.5, 2, 1 ) {
        my $test_scale = $scale_divider * $scale_size;

        if ( $self->range->span / $test_scale >= $minimum_target_ticks ) {
            $scale_size = $test_scale;
            last ADJUSTSCALE;
        }
    }

    return $scale_size;
}

sub _real_divvy {
    my ($self) = @_;

    my $tickSize = $self->best_tick_size;
    my $range    = $self->range;

    # If the lowest value is nearby to the first tick below it (gap
    # at front of graph would be low) then use that as the starting
    # value; otherwise choose the first tick value above the lowest.
    my $lowestTick        = int( $range->lower() / $tickSize ) * $tickSize;
    my $lowestValue       = $range->lower();
    my $lowTickDifference = $lowestValue - $lowestTick;

    if ( $lowTickDifference > $self->tick_slop * $tickSize ) {
        $lowestTick = $lowestTick + $tickSize;
    }
    if ( $lowestTick < $lowestValue ) {
        $lowestValue = $lowestTick;
    }
    $range->lower($lowestValue);
    my @vals;
    push( @vals, $lowestTick );

    # Loop until upper from the starting point
    my $lastTick = $lowestTick;
    while ( $range->upper - $tickSize > $lastTick ) {
        $lastTick = $lastTick + $tickSize;

        push( @vals, $lastTick );
    }

    # If the upper value is nearby to the last tick above it
    # (gap at end of graph would be low) then use that as the
    # ending value; otherwise use the tick value immediately before
    # the upper value.
    my $potentialUpperTick = $lastTick + $tickSize;
    if ( $potentialUpperTick - $range->upper < $self->tick_slop * $tickSize ) {
        $range->upper($potentialUpperTick);
        push( @vals, $potentialUpperTick );
    }

    return \@vals;
}

no Moose;
1;
__END__

=head1 NAME

Chart::Clicker::Axis::DivisionType::RoundedLinear - Nicely rounded segments on a linear scale.

=head1 DESCRIPTION

Role describing how to divide data for Chart::Clicker::Axis.

=head1 SYNOPSIS

  use Chart::Clicker::Axis;

  my $axis = Chart::Clicker::Axis->new({
    tick_division_type  => 'RoundedLinear'
  });

=head1 ATTRIBUTES

=head2 tick_slop

This setting determines whether to add a tick outside of the data. If the tick would be
within the percentage of a ticks size specified here as a decimal (10% would be 0.1), then
the tick will be added expanding the graph.

=head1 METHODS

=head2 best_tick_size

The tick division considered best for the approximate number of ticks requested
and data within the range.

=head2 divvy

Divides the range up into nicely rounded chunks for L<Chart::Clicker::Axis>.

=head1 AUTHOR

Rod Taylor <chartclicker@rbt.ca>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.

