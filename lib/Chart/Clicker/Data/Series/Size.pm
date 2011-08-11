package Chart::Clicker::Data::Series::Size;
use Moose;

extends 'Chart::Clicker::Data::Series';

# ABSTRACT: Chart data with additional attributes for Size charts

use List::Util qw(min max);

=head1 DESCRIPTION

Chart::Clicker::Data::Series::Size is an extension of the Series class
that provides storage for a third variable called the size.  This is useful
for the Bubble renderer.

=head1 SYNOPSIS

  use Chart::Clicker::Data::Series::Size;

  my @keys = ();
  my @values = ();
  my @sizes = ();

  my $series = Chart::Clicker::Data::Series::Size->new({
    keys    => \@keys,
    values  => \@values,
    sizes   => \@sizes
  });

=attr sizes

Set/Get the sizes for this series.

=method add_to_sizes

Adds a size to this series.

=method get_size

Get a size by it's index.

=method size_count

Gets the count of sizes in this series.

=cut

has 'sizes' => (
    traits => [ 'Array' ],
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    handles => {
        'add_to_sizes' => 'push',
        'size_count' => 'count',
        'get_size' => 'get'
    }
);

=attr max_size

Gets the largest value from this Series' C<sizes>.

=cut

has max_size => (
    is => 'ro',
    isa => 'Num',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        return max(@{ $self->sizes });
    }
);

=attr min_size

Gets the smallest value from this Series' C<sizes>.

=cut

has min_size => (
    is => 'ro',
    isa => 'Num',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        return min(@{ $self->sizes });
    }
);

__PACKAGE__->meta->make_immutable;

no Moose;

1;