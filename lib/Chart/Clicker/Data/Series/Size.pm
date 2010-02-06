package Chart::Clicker::Data::Series::Size;
use Moose;

extends 'Chart::Clicker::Data::Series';

use List::Util qw(min max);

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

has max_size => (
    is => 'ro',
    isa => 'Num',
    lazy_build => 1
);

has min_size => (
    is => 'ro',
    isa => 'Num',
    lazy_build => 1
);

sub _build_max_size {
    my ($self) = @_;

    return max(@{ $self->sizes });
}

sub _build_min_size {
    my ($self) = @_;

    return min(@{ $self->sizes });
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;

__END__

=head1 NAME

Chart::Clicker::Data::Series::Size

=head1 DESCRIPTION

Chart::Clicker::Data::Series::Size is an extension of the Series class
that provides storage for a third variable called the size.  This is useful
for the Bubble renderer.

=head1 SYNOPSIS

  use Chart::Clicker::Data::Series::Size;

  my $series = Chart::Clicker::Data::Series::Size->new({
    keys    => \@keys,
    values  => \@values,
    sizes   => \@sized
  });

=head1 ATTRIBUTES

=head2 sizes

Set/Get the sizes for this series.

=head2 max_size

Gets the largest value from this Series' C<sizes>.

=head2 min_size

Gets the smallest value from this Series' C<sizes>.

=head1 METHODS

=head2 new

Creates a new, empty Series::Size

=head2 add_to_sizes

Adds a size to this series.

=head2 get_size

Get a size by it's index.

=head2 size_count

Gets the count of sizes in this series.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.

1;