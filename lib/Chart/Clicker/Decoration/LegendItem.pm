package Chart::Clicker::Decoration::LegendItem;
use Moose;

extends 'Chart::Clicker::Decoration';

use Chart::Clicker::Drawing::Font;

has 'color' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Color'
);

has 'font' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Font'
);

has 'label' => (
    is => 'rw',
    isa => 'Str'
);

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::LegendItem

=head1 DESCRIPTION

Chart::Clicker::Decoration::LegendItem represents a single item in a legend.

=head1 SYNOPSIS

  use Chart::Clicker::Decoration::LegendItem;
  use Chart::Clicker::Drawing::Color;
  use Chart::Clicker::Drawing::Font;
  use Chart::Clicker::Drawing::Insets;

  my $li = new Chart::Clicker::Decoration::LegendItem({
    color   => new Chart::Clicker::Drawing::Color({ name => 'black' }),
    insets  => new Chart::Clicker::Drawings::Insets(),
    label   => 'foo',
    font    => new Chart::Clicker::Drawing::Font()
  });

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new LegendItem object.

=back

=head2 Class Methods

=over 4

=item color

Set/Get this legend item's color.

=item insets

Set/Get this legend item's insets.

=item label

Set/Get this legend item's label.

=item font

Set/Get this legend item's font.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
