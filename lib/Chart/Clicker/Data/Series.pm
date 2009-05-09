package Chart::Clicker::Data::Series;
use Moose;
use MooseX::AttributeHelpers;

use List::Util qw(max min);
use Chart::Clicker::Data::Range;

has 'keys' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef[Num]',
    default => sub { [] },
    provides => {
        'push' => 'add_to_keys',
        'count' => 'key_count'
    }
);
has 'name' => ( is => 'rw', isa => 'Str' );
has 'range' => (
    is => 'rw',
    isa => 'Chart::Clicker::Data::Range',
    lazy => 1,
    default => sub { my $self = shift; $self->find_range }
);
has 'values' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef[Num]',
    default => sub { [] },
    provides => {
        'push' => 'add_to_values',
        'count' => 'value_count'
    }
);

sub find_range {
    my ($self) = @_;

    my $values = $self->values;

    return Chart::Clicker::Data::Range->new(
        lower => min(@{ $self->values }), upper => max(@{ $self->values})
    );
}

sub prepare {
    my ($self) = @_;

    if($self->key_count != $self->value_count) {
        die('Series key/value counts dont match.');
    }

    return 1;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Data::Series

=head1 DESCRIPTION

Chart::Clicker::Data::Series represents a series of values to be charted.

=head1 SYNOPSIS

  use Chart::Clicker::Data::Series;

  my @keys = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  my @values = (42, 25, 86, 23, 2, 19, 103, 12, 54, 9);

  my $series = Chart::Clicker::Data::Series->new({
    keys    => \@keys,
    value   => \@values
  });

=head1 METHODS

=head2 new

Creates a new, empty Series

=head2 add_to_keys

Adds a key to this series.

=head2 add_to_values

Add a value to this series.

=head2 find_range

Used internally to determine the range for this series.  Exposed so that
subclasses can implement their own method.

=head2 keys

Set/Get the keys for this series.

=head2 key_count

Get the count of keys in this series.

=head2 name

Set/Get the name for this Series

=head2 prepare

Prepare this series.  Performs various checks and calculates
various things.

=head2 range

Returns the range for this series.

=head2 value_count

Get the count of values in this series.

=head2 values

Set/Get the values for this series.

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
