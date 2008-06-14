package Chart::Clicker::Data::Range;
use Moose;

has 'lower' => ( is => 'rw', isa => 'Num' );
has 'upper' => ( is => 'rw', isa => 'Num' );
has 'min' => ( is => 'rw', isa => 'Num' );
has 'max' => ( is => 'rw', isa => 'Num' );

after 'lower' => sub {
    my $self = shift();

    if(defined($self->{'min'})) {
        $self->{'lower'} = $self->{'min'};
    }
};

after 'upper' => sub {
    my $self = shift();

    if(defined($self->{'max'})) {
        $self->{'upper'} = $self->{'max'};
    }
};

after 'min' => sub {
    my $self = shift();

    if(defined($self->{'min'})) {
        $self->{'lower'} = $self->{'min'};
    }
};

after 'max' => sub {
    my $self = shift();

    if(defined($self->{'max'})) {
        $self->{'upper'} = $self->{'max'};
    }
};

sub span {
    my $self = shift();

    return ($self->upper() - $self->lower());
}

sub combine {
    my $self = shift();
    my $range = shift();

    unless(defined($self->min())) {
        if(!defined($self->lower()) || ($range->lower() < $self->lower())) {
            $self->lower($range->lower());
        }
    }

    unless(defined($self->max())) {
        if(!defined($self->upper()) || ($range->upper() > $self->upper())) {
            $self->upper($range->upper());
        }
    }

    return 1;
}

sub add {
    my $self = shift();
    my $range = shift();

    if(defined($self->upper())) {
        $self->upper($self->upper() + $range->upper());
    } else {
        $self->upper($range->upper());
    }

    if(!defined($self->lower()) || ($range->lower() < $self->lower())) {
        $self->lower($range->lower());
    }
}

sub divvy {
    my $self = shift();
    my $n = shift();

    if(!$n) {
        return [];
    }

    my $per = $self->span() / $n;

    my @vals;
    for(1..($n - 1)) {
        push(@vals, $self->lower() + ($_ * $per));
    }

    return \@vals;
}

1;
__END__

=head1 NAME

Chart::Clicker::Data::Range

=head1 DESCRIPTION

Chart::Clicker::Data::Range implements a range of values.

=head1 SYNOPSIS

  use Chart::Clicker::Data::Range;

  my $range = new Chart::Clicker::Data::Range({
    lower => 1,
    upper => 10
  });

=head1 METHODS

=head2 Constructors

=over 4

=item new

Creates a new, empty Series

=item lower

Set/Get the lower bound for this Range

=item min

Set/Get the minimum value allowed for this Range.  This value should only be
set if you want to EXPLICITLY set the lower value.

=item upper

Set/Get the upper bound for this Range

=item max

Set/Get the maximum value allowed for this Range.  This value should only be
set if you want to EXPLICITLY set the upper value.

=item span

Returns the span of this range, or UPPER - LOWER.

=item combine

Combine this range with the specified so that this range encompasses the
values specified.  For example, adding a range with an upper-lower of 1-10
with one of 5-20 will result in a combined range of 1-20.

=item add

Adds the specified range to this one.  The lower is reduced to that of the
provided one if it is lower, and the upper is ADDED to this range's upper.

=item divvy

  my $values = $range->divvy(5);

Returns an arrayref of $N - 1 values equally spaced in the range so that
it may be divided into $N pieces.

=back

=head1 AUTHOR

Cory 'G' Watson <jheephat@cpan.org>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
