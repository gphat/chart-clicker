package Chart::Clicker::Data::Series::HighLow;
use Moose;

extends 'Chart::Clicker::Data::Series';

use List::Util qw(max min);

has 'highs' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        'push' => 'add_to_highs',
        'count' => 'high_count',
        'get' => 'get_high'
    }
);

has 'lows' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        'push' => 'add_to_lows',
        'count' => 'low_count',
        'get' => 'get_low'
    }
);

has 'opens' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        'push' => 'add_to_opens',
        'count' => 'open_count',
        'get' => 'get_open'
    }
);

sub find_range {
    my ($self) = @_;

    return Chart::Clicker::Data::Range->new(
        lower => min(@{ $self->lows }),
        upper => max(@{ $self->highs })
    );
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;

__END__

=head1 NAME

Chart::Clicker::Data::Series::HighLow

=head1 DESCRIPTION

Chart::Clicker::Data::Series::HighLow is an extension of the Series class
that provides storage for a three new variables called for use with the
CandleStick renderer.  The general idea is:

  --- <-- High
   |
   |
   -  <-- max of Open, Value
  | |
  | |
   -  <-- min of Open, Value
   |
   |
  --- <-- Low

=head1 SYNOPSIS

  use Chart::Clicker::Data::Series::HighLow;

  my $series = Chart::Clicker::Data::Series::HighLow->new({
    keys    => \@keys,
    values  => \@values,
    highs   => \@highs,
    lows    => \@lows,
    opens   => \@opens
  });

=head1 METHODS

=head2 new

Creates a new, empty Series::Size

=head2 add_to_highs

Adds a high to this series.

=head2 add_to_lows

Adds a high to this series.

=head2 add_to_opens

Adds an open to this series.

=head2 get_high

Get a high by it's index.

=head2 get_low

Get a low by it's index.

=head2 get_open

Get an open by it's index.

=head2 highs

Set/Get the highs for this series.

=head2 lows

Set/Get the lows for this series.

=head2 opens

Set/Get the opens for this series.

=head2 high_count

Gets the count of sizes in this series.

=head2 low_count

Gets the count of lows in this series.

=head2 open_count

Gets the count of opens in this series.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.

1;