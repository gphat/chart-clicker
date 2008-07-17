package Chart::Clicker::Data::DataSet;
use Moose;

use MooseX::AttributeHelpers;

use Chart::Clicker::Data::Range;

has 'combined_range' => (
    is => 'rw',
    isa => 'Chart::Clicker::Data::Range',
    default => sub { Chart::Clicker::Data::Range->new() }
);
has 'context' => (
    is => 'rw',
    isa => 'Str',
    default => sub { 'default'}
);
has 'domain' => (
    is => 'rw',
    isa => 'Chart::Clicker::Data::Range',
    default => sub { Chart::Clicker::Data::Range->new() }
);
has 'max_key_count' => ( is => 'rw', isa => 'Int', default => 0 );
has 'range' => (
    is => 'rw',
    isa => 'Chart::Clicker::Data::Range',
    default => sub { Chart::Clicker::Data::Range->new() }
);
has 'series' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        'count' => 'count',
        'push' => 'add_to_series',
        'get' => 'get_series'
    }
);

sub get_series_keys {
    my ($self, $position) = @_;

    return map({ $_->keys->[$position] } @{ $self->series });
}

sub get_series_values {
    my ($self, $position) = @_;

    return map({ $_->values->[$position] } @{ $self->series });
}

sub prepare {
    my $self = shift();

    unless($self->count() && $self->count() > 0) {
        die('Dataset has no series.');
    }

    my $stotal;
    foreach my $series (@{ $self->series() }) {
        $series->prepare();

        $self->range->combine($series->range());
        $self->combined_range->add($series->range());

        my @keys = @{ $series->keys() };

        $self->domain->combine(
            Chart::Clicker::Data::Range->new({
                lower => $keys[0], upper => $keys[ $#keys ]
            })
        );

        if($series->key_count() > $self->max_key_count()) {
            $self->max_key_count($series->key_count());
        }
    }

    return 1;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Data::DataSet

=head1 DESCRIPTION

Chart::Clicker::Data::DataSet is a set of Series that are grouped for some
logical reason or another.  DatasSets can be associated with Renderers in the
Chart.   Unless you are doing something fancy like that you have no reason
to use more than one in your chart.

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

=head1 METHODS

=head2 Constructors

=over 4

=item I<new>

Creates a new, empty DataSet

=back

=head2 Instance Methods

=over 4

=item I<add_to_series>

Add a series to this dataset.

=item I<count>

Get the number of series in this dataset.

=item I<domain>

Get the Range for the domain values

=item I<get_series_keys>

Returns the key at the specified position for every series in this DataSet.

=item I<get_series_values>

Returns the value at the specified position for every series in this DataSet.

=item I<max_key_count>

Get the number of keys in the longest series.

=item I<range>

Get the Range for the... range values...

=item I<series>

Set/Get the series for this DataSet

=item I<prepare>

Prepare this DataSet.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
