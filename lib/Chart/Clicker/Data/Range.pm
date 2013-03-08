package Chart::Clicker::Data::Range;
use Moose;
use Moose::Util::TypeConstraints;

use constant EPSILON => 0.0001;

# ABSTRACT: A range of Data

=head1 DESCRIPTION

Chart::Clicker::Data::Range implements a range of values.

=head1 SYNOPSIS

  use Chart::Clicker::Data::Range;

  my $range = Chart::Clicker::Data::Range->new({
    lower => 1,
    upper => 10
  });

=attr lower

Set/Get the lower bound for this Range

=cut

subtype 'Lower'
    => as 'Num|Undef'
    => where { defined($_) };

coerce 'Lower'
    => from 'Undef'
    => via { - EPSILON };

has 'lower' => ( is => 'rw', isa => 'Lower', coerce => 1);

=attr max

Set/Get the maximum value allowed for this Range.  This value should only be
set if you want to EXPLICITLY set the upper value.

=cut

has 'max' => ( is => 'rw', isa => 'Num' );

=attr min

Set/Get the minimum value allowed for this Range.  This value should only be
set if you want to EXPLICITLY set the lower value.

=cut

has 'min' => ( is => 'rw', isa => 'Num' );

=attr upper

Set/Get the upper bound for this Range

=cut

subtype 'Upper'
    => as 'Num|Undef'
    => where { defined($_) };

coerce 'Upper'
    => from 'Num|Undef'
    => via { EPSILON };

has 'upper' => ( is => 'rw', isa => 'Upper', coerce => 1);


=attr ticks

The number of ticks to be displayed for this range.

=cut

has 'ticks' => ( is => 'rw', isa => 'Int', default    => 5 );


after 'lower' => sub {
    my $self = shift;

    if(defined($self->{'min'})) {
        $self->{'lower'} = $self->{'min'};
    }

    $self->{'lower'} = $self->{'min'} unless (defined($self->{'lower'}));
    $self->{'upper'} = $self->{'max'} unless (defined($self->{'upper'}));

    if(defined($self->{'lower'}) && defined($self->{'upper'}) && $self->{'lower'} == $self->{'upper'}) {
        $self->{'lower'} = $self->{'lower'} - EPSILON;
        $self->{'lower'} = $self->{'lower'} + EPSILON;
    }

};

after 'upper' => sub {
    my $self = shift;

    if(defined($self->{'max'})) {
        $self->{'upper'} = $self->{'max'};
    }

    $self->{'lower'} = $self->{'min'} unless (defined($self->{'lower'}));
    $self->{'upper'} = $self->{'max'} unless (defined($self->{'upper'}));

    if(defined($self->{'lower'}) && defined($self->{'upper'}) && $self->{'lower'} == $self->{'upper'}) {
        $self->{'upper'} = $self->{'upper'} - EPSILON;
        $self->{'upper'} = $self->{'upper'} + EPSILON;
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

=method add

Adds the specified range to this one.  The lower is reduced to that of the
provided one if it is lower, and the upper is ADDED to this range's upper.

=cut

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

=method combine

Combine this range with the specified so that this range encompasses the
values specified.  For example, adding a range with an upper-lower of 1-10
with one of 5-20 will result in a combined range of 1-20.

=cut

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

=method contains ($value)

Returns true if supplied value falls within this range (inclusive).  Otherwise
returns false.

=cut

sub contains {
    my ($self, $value) = @_;

    return 1 if $value >= $self->lower && $value <= $self->upper;
    return 0;
}

=method span

Returns the span of this range, or UPPER - LOWER.

=cut

sub span {
    my ($self) = @_;

    my $span = $self->upper - $self->lower;

    #we still want to be able to see flat lines!
    if ($span <= EPSILON) {
        $self->upper($self->upper() + EPSILON);
        $self->lower($self->lower() - EPSILON);
        $span = $self->upper - $self->lower;
    }
    return $span;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
