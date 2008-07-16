package Chart::Clicker::Data::Series::Size;
use Moose;

extends 'Chart::Clicker::Data::Series';

has 'sizes' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        'push' => 'add_to_sizes',
        'count' => 'size_count',
        'get' => 'get_size'
    }
);

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

=head1 METHODS

=head2 Constructors

=over 4

=item I<new>

Creates a new, empty Series::Size

=back

=head2 Methods

=over 4

=item I<add_to_sizes>

Adds a size to this series.

=item I<get_size>

Get a size by it's index.

=item I<sizes>

Set/Get the sizes for this series.

=item I<size_count>

Gets the count of sizes in this series.

=back

=head1 AUTHOR

Cory 'G' Watson <jheephat@cpan.org>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.

1;