package Chart::Clicker::Data::Range;
use Moose;

use POSIX qw(ceil floor);

use Chart::Clicker::Types qw(DivvyStrategy);

has 'lower' => ( is => 'rw', isa => 'Num' );
has 'max' => ( is => 'rw', isa => 'Num' );
has 'min' => ( is => 'rw', isa => 'Num' );
has 'divvy_strategy' => ( is => 'rw', isa => DivvyStrategy, default => 'loose' );
has 'upper' => ( is => 'rw', isa => 'Num' );

after 'lower' => sub {
    my $self = shift;

    if(defined($self->{'min'})) {
        $self->{'lower'} = $self->{'min'};
    }
};

after 'upper' => sub {
    my $self = shift;

    if(defined($self->{'max'})) {
        $self->{'upper'} = $self->{'max'};
    }
};

after 'min' => sub {
    my $self = shift;

    if(defined($self->{'min'})) {
        $self->{'lower'} = $self->{'min'};
    }
};

after 'max' => sub {
    my $self = shift;

    if(defined($self->{'max'})) {
        $self->{'upper'} = $self->{'max'};
    }
};

sub add {
    my ($self, $range) = @_;

    if(defined($self->upper)) {
        $self->upper($self->upper + $range->upper);
    } else {
        $self->upper($range->upper);
    }

    if(!defined($self->lower) || ($range->lower < $self->lower)) {
        $self->lower($range->lower);
    }
}

sub combine {
    my ($self, $range) = @_;

    unless(defined($self->min)) {
        if(!defined($self->lower) || ($range->lower < $self->lower)) {
            $self->lower($range->lower);
        }
    }

    unless(defined($self->max)) {
        if(!defined($self->upper) || ($range->upper > $self->upper)) {
            $self->upper($range->upper);
        }
    }

    return 1;
}

sub contains {
    my ($self, $value) = @_;

    return 1 if $value >= $self->lower && $value <= $self->upper;
    return 0;
}

sub divvy {
    my ($self, $n) = @_;

    if(!$n) {
        return [];
    }

    if($self->divvy_strategy eq 'tight') {
        return $self->_loose_ticks(1, $n);
    } elsif($self->divvy_strategy eq 'loose') {
        return $self->_loose_ticks(0, $n);
    }  else {
        return $self->_even_ticks($n);
    }
}

sub _even_ticks {
    my ($self, $n) = @_;

    my $per = $self->span / ($n - 1);

    my @vals;
    for(0..($n - 1)) {
        push(@vals, $self->lower + ($_ * $per));
    }

    return \@vals;
}

sub _loose_ticks {
    my ($self, $tight, $n) = @_;

    if(!$n) {
        return [];
    }

    my $min = $self->lower;
    my $max = $self->upper;

    my $range = _nicenum($self->span, 0);
    print "$range\n";
    my $d = _nicenum($range / ($n - 1), 1);
    my $graphmin = $min;
    my $graphmax = $max;
    if(!$tight) {
        # If we aren't tight then we can expand
        $graphmin = floor($min / $d) * $d;
        $self->min($graphmin);
        $graphmax = ceil($max / $d) * $d;
        $self->max($graphmax);
    }

    my $x = $graphmin;
    my @ticks;
    do {
        push(@ticks, $x);
        $x += .5 * $d;
    } while($x < $graphmax);

    if($tight) {
        # Add one more in the tight case, as the last one exceeds the
        # charted area and we need one more
        use Data::Dumper;
        print Dumper(\@ticks);
        # push(@ticks, $graphmax);
    }

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

sub span {
    my ($self) = @_;

    return $self->upper - $self->lower;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Data::Range

=head1 DESCRIPTION

Chart::Clicker::Data::Range implements a range of values.

=head1 SYNOPSIS

  use Chart::Clicker::Data::Range;

  my $range = Chart::Clicker::Data::Range->new({
    lower => 1,
    upper => 10
  });

=head1 ATTRIBUTES

=head2 lower

Set/Get the lower bound for this Range

=head2 max

Set/Get the maximum value allowed for this Range.  This value should only be
set if you want to EXPLICITLY set the upper value.

=head2 min

Set/Get the minimum value allowed for this Range.  This value should only be
set if you want to EXPLICITLY set the lower value.

=head2 upper

Set/Get the upper bound for this Range

=head1 METHODS

=head2 new

Creates a new, empty Series

=head2 add

Adds the specified range to this one.  The lower is reduced to that of the
provided one if it is lower, and the upper is ADDED to this range's upper.

=head2 combine

Combine this range with the specified so that this range encompasses the
values specified.  For example, adding a range with an upper-lower of 1-10
with one of 5-20 will result in a combined range of 1-20.

=head2 contains ($value)

Returns true if supplied value falls within this range (inclusive).  Otherwise
returns false.

=head2 divvy

  my $values = $range->divvy(5);

Returns an arrayref of $N - 1 values equally spaced in the range so that
it may be divided into $N pieces.

=head2 span

Returns the span of this range, or UPPER - LOWER.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
