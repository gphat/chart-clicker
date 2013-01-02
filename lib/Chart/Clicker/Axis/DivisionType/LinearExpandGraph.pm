package Chart::Clicker::Axis::DivisionType::LinearExpandGraph;

use Moose::Role;
with qw{Chart::Clicker::Axis::DivisionType};

use POSIX qw(ceil floor);

# Positive only
has 'tick_slop' => (
    is      => 'rw',
    isa     => 'Num',
    default => 0.1,
    documentation =>
        q{Percent of a tick unit above or below graphed which we allow inserting an additional tick. Whitespace allowance above or below.}
);

sub _real_divvy {
    my ($self) = @_;

	my $n = $self->ticks;

    my $min = $self->range->lower;
    my $max = $self->range->upper;

    my $range = _nicenum($self->range->span, 0);
    print "$range\n";
    my $d = _nicenum($range / ($n - 1), 1);
    my $graphmin = $min;
    my $graphmax = $max;

    # Expand the graph as needed
    $graphmin = floor($min / $d) * $d;
    $self->range->min($graphmin);
    $graphmax = ceil($max / $d) * $d;
    $self->range->max($graphmax);

    my $x = $graphmin;
    my @ticks;
    do {
        push(@ticks, $x);
        $x += .5 * $d;
    } while($x < $graphmax);

    return \@ticks;
}

sub _nicenum {
    my ($num, $round) = @_;

    my $exp = floor(_log10($num));
    my $f = $num / (10 ** $exp);
    my $nice;

    if($round) {
        if($f < 1.5) {
            $nice = 1.5;
        } elsif($f < 3) {
            $nice = 2;
        } elsif($f < 7) {
            $nice = 5;
        } else {
            $nice = 10;
        }
    } else {
        if($f <= 1) {
            $nice = 1;
        } elsif($f <= 2) {
            $nice = 2;
        } elsif($f <= 5) {
            $nice = 5;
        } else {
            $nice = 10;
        }
    }

    return $nice * (10 ** $exp);
}

 	

sub _log10 {
    my $n = shift;
    return log($n) / log(10);
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

