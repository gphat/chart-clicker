package Chart::Clicker::Data::DataSet;
use Moose;

# ABSTRACT: A collection of series

use Chart::Clicker::Data::Range;

=head1 DESCRIPTION

Chart::Clicker::Data::DataSet is a set of Series that are grouped for some
logical reason or another.  DatasSets can be associated with Renderers in the
Chart.  Unless you are doing something fancy like that you have no reason to
use more than one in your chart.

=head1 SYNOPSIS

  use Chart::Clicker::Data::DataSet;
  use Chart::Clicker::Data::Series;

  my @vals = (12, 19, 90, 4, 44, 3, 78, 87, 19, 5);
  my @keys = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  my $series = Chart::Clicker::Data::Series->new({
    keys    => \@keys,
    values  => \@values
  });

  my $ds = Chart::Clicker::Data::DataSet->new({
    series => [ $series ]
  });

=attr context

Set/Get the context this DataSet will be charted under.

=cut

has 'context' => (
    is => 'rw',
    isa => 'Str',
    default => sub { 'default'}
);

=attr domain

Get the Range for the domain values

=cut

has 'domain' => (
    is => 'rw',
    isa => 'Chart::Clicker::Data::Range',
    default => sub { Chart::Clicker::Data::Range->new }
);

=head2 max_key_count

Get the number of keys in the longest series.  This will be set automatically.

=cut

has 'max_key_count' => ( is => 'rw', isa => 'Int', default => 0 );

=attr range

Get the Range for the... range values...

=cut

has 'range' => (
    is => 'rw',
    isa => 'Chart::Clicker::Data::Range',
    default => sub { Chart::Clicker::Data::Range->new }
);

=attr series

Set/Get the series for this DataSet

=method add_to_series

Add a series to this dataset.

=method count

Get the number of series in this dataset.

=method get_series ($index)

Get the series at the specified index.

=cut

has 'series' => (
    traits => [ 'Array' ],
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    handles => {
        'count' => 'count',
        'add_to_series' => 'push',
        'get_series' => 'get'
    }
);

=method get_all_series_keys

Returns an array of keys representing the union of all keys from all DataSets.

=cut

sub get_all_series_keys {
    my ($self) = @_;

    my %keys;
    for my $series (@{$self->series}) {
        foreach (@{$series->keys}) { $keys{$_} = 1};
    }
    return keys %keys;
}

=method get_series_keys

Returns the key at the specified position for every series in this DataSet.

=cut

sub get_series_keys {
    my ($self, $position) = @_;

    return map({ $_->keys->[$position] } @{ $self->series });
}

=method get_series_values

Returns the value at the specified position for every series in this DataSet
as an ArrayRef.

=cut

sub get_series_values {
    my ($self, $position) = @_;

    return [ map({ $_->values->[$position] } @{ $self->series }) ];
}

=method get_series_values_for_key

Returns the value for the specified key for every series in this DataSet as an
ArrayRef.

=cut

sub get_series_values_for_key {
    my ($self, $key) = @_;

    return [ map({ $_->get_value_for_key($key) } @{ $self->series }) ];
}

=method largest_value_slice

Finds the largest cumulative 'slice' in this dataset.

=cut

sub largest_value_slice {
    my ($self) = @_;

    # Prime out big variable with the value of the first slice
    my $big;
    foreach (@{ $self->get_series_values(0) }) { $big += $_; }

    # Check that value against all the remaining slices
    for my $i (0 .. $self->max_key_count - 1) {
        my $t;
        foreach (@{ $self->get_series_values($i) }) { $t += $_ if defined($_); }
        $big = $t if(($t > $big) || !defined($big));
    }
    return $big;
}

sub prepare {
    my ($self) = @_;

    unless($self->count && $self->count > 0) {
        die('Dataset has no series.');
    }

    my $stotal;
    foreach my $series (@{ $self->series }) {
        $series->prepare;

        $self->range->combine($series->range);

        my @keys = @{ $series->keys };

        $self->domain->combine(
            Chart::Clicker::Data::Range->new({
                lower => $keys[0], upper => $keys[ $#keys ]
            })
        );

        if($series->key_count > $self->max_key_count) {
            $self->max_key_count($series->key_count);
        }
    }

    return 1;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;