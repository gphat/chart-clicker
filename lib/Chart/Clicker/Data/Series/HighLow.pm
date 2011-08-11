package Chart::Clicker::Data::Series::HighLow;
use Moose;

extends 'Chart::Clicker::Data::Series';

# ABSTRACT: Series data with additional attributes for High-Low charts

use List::Util qw(max min);

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

  my @keys = ();
  my @values = ();
  my @highs = ();
  my @lows = ();
  my @opens = ();

  my $series = Chart::Clicker::Data::Series::HighLow->new({
    keys    => \@keys,
    values  => \@values,
    highs   => \@highs,
    lows    => \@lows,
    opens   => \@opens
  });

=cut

sub _build_range {
    my ($self) = @_;

    return Chart::Clicker::Data::Range->new(
        lower => min(@{ $self->lows }),
        upper => max(@{ $self->highs })
    );
}

=attr highs

Set/Get the highs for this series.

=method add_to_highs

Adds a high to this series.

=method get_high ($index)

Get a high by it's index.

=method high_count

Gets the count of sizes in this series.

=cut

has 'highs' => (
    traits => [ 'Array' ],
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    handles => {
        'add_to_highs' => 'push',
        'high_count' => 'count',
        'get_high' => 'get'
    }
);

=attr lows

Set/Get the lows for this series.

=method add_to_lows

Adds a high to this series.

=method get_low ($index)

Get a low by it's index.

=method low_count

Gets the count of lows in this series.

=cut

has 'lows' => (
    traits => [ 'Array' ],
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    handles => {
        'add_to_lows' => 'push',
        'low_count' => 'count',
        'get_low' => 'get'
    }
);

=attr opens

Set/Get the opens for this series.

=method add_to_opens

Adds an open to this series.

=method get_open

Get an open by it's index.

=method open_count

Gets the count of opens in this series.

=cut

has 'opens' => (
    traits => [ 'Array' ],
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    handles => {
        'add_to_opens' => 'push',
        'open_count' => 'count',
        'get_open' => 'get'
    }
);

__PACKAGE__->meta->make_immutable;

no Moose;

1;