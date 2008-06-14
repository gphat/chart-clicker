package Chart::Clicker::Data::DataSet;
use Moose;

use Chart::Clicker::Data::Range;

has 'count' => (
    is => 'rw',
    isa => 'Int',
    default => 0,
);
has 'series' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    trigger => sub { my ($self, $series) = @_; $self->count(scalar(@{ $series })) }
);
has 'domain' => (
    is => 'rw',
    isa => 'Chart::Clicker::Data::Range',
    default => sub { new Chart::Clicker::Data::Range() }
);
has 'max_key_count' => ( is => 'rw', isa => 'Int', default => 0 );
has 'range' => (
    is => 'rw',
    isa => 'Chart::Clicker::Data::Range',
    default => sub { new Chart::Clicker::Data::Range() }
);
has 'combined_range' => (
    is => 'rw',
    isa => 'Chart::Clicker::Data::Range',
    default => sub { new Chart::Clicker::Data::Range() }
);

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
            new Chart::Clicker::Data::Range({
                lower => $keys[0], upper => $keys[ $#keys ]
            })
        );

        if($series->key_count() > $self->max_key_count()) {
            $self->max_key_count($series->key_count());
        }
    }

    return 1;
}

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
  my $series = new Chart::Clicker::Data::Series({
    keys    => \@keys,
    values  => \@values
  });

  my $ds = new Chart::Clicker::Data::DataSet({
    series => [ $series ]
  });

=head1 METHODS

=head2 Constructors

=over 4

=item new

Creates a new, empty DataSet

=back

=head2 Class Methods

=over 4

=item count

Get the number of series in this dataset.

=item domain

Get the Range for the domain values

=item max_key_count

Get the number of keys in the longest series.

=item range

Get the Range for the... range values...

=item series

Set/Get the series for this DataSet

=item prepare

Prepare this DataSet.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
