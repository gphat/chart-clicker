package Chart::Clicker::Data::Series;
use Moose;

use Chart::Clicker::Data::Range;

has 'error_count' => ( is => 'rw', isa => 'Int' );
has 'errors' => ( is => 'rw', isa => 'Num' );
has 'key_count' => ( is => 'rw', isa => 'Int' );
has 'value_count' => ( is => 'rw', isa => 'Int' );
has 'name' => ( is => 'rw', isa => 'Str' );
has 'range' => (
    is => 'rw',
    isa => 'Chart::Clicker::Data::Range',
    default => sub { new Chart::Clicker::Data::Range() }
);
has 'keys' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    trigger => sub { my ($self, $keys) = @_; $self->key_count(scalar(@{ $keys })) }
);
has 'values' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    trigger => sub { my ($self, $values) = @_; $self->value_count(scalar(@{ $values })) }
);

sub prepare {
    my $self = shift();

    my $values = $self->values();
    my $keys = $self->keys();

    $self->key_count(scalar(@{ $keys }));
    $self->value_count(scalar(@{ $values }));

    if($self->key_count() != $self->value_count()) {
        die('Series key/value counts dont match.');
    }

    if($self->errors()) {
        my @errors = @{ $self->errors() };
        $self->error_count(scalar(@errors));

        if($self->error_count() != $self->value_count()) {
            die('Series error/value counts don\'t match');
        }
    }

    my ($long, $max, $min);
    $long = 0;
    $max = $values->[0];
    $min = $values->[0];
    my $count = 0;
    foreach my $key (@{ $self->keys() }) {

        my $val = $values->[$count];

        # Max
        if($val > $max) {
            $max = $val;
        }

        # Min
        if($val < $min) {
            $min = $val;
        }
        $count++;
    }
    $self->range(
        new Chart::Clicker::Data::Range({ lower => $min, upper => $max })
    );

    return 1;
}

1;
__END__

=head1 NAME

Chart::Clicker::Data::Series

=head1 DESCRIPTION

Chart::Clicker::Data::Series is the core class 

=head1 SYNOPSIS

  use Chart::Clicker::Data::Series;

  my @keys = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  my @values = (42, 25, 86, 23, 2, 19, 103, 12, 54, 9);

  my $series = new Chart::Clicker::Data::Series({
    keys    => \@keys,
    value   => \@values
  });

=head1 METHODS

=head2 Constructors

=over 4

=item new

Creates a new, empty Series

=item count

Return a count of the number of values in this series.  Only available
after the series has been prepared.

=item errors

Set/Get the errors for this series.

=item key_count

Return a count of the number of keys in this series.  Only available
after the series has been prepared.

=item keys

Set/Get the keys for this series.

=item name

Set/Get the name for this Series

=item numeric_keys

Set/Get the flag that denotes if this series' keys are all numeric.

=item prepare

Prepare this series.  Performs various checks and calculates
various things.

=item range

Returns the range for this series.

=item values

Set/Get the values for this series.

=back

=head1 AUTHOR

Cory 'G' Watson <jheephat@cpan.org>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
