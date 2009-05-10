package Chart::Clicker::Decoration::LegendItem;
use Moose;

extends 'Chart::Clicker::Component';

# TODO Hmmm...

use Graphics::Primitive::Font;

has 'font' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Font'
);

has 'label' => (
    is => 'rw',
    isa => 'Str'
);

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::LegendItem

=head1 DESCRIPTION

Chart::Clicker::Decoration::LegendItem represents a single item in a legend.

=head1 SYNOPSIS

  use Chart::Clicker::Decoration::LegendItem;
  use Graphics::Primitive::Font;
  use Chart::Clicker::Drawing::Insets;

  my $li = Chart::Clicker::Decoration::LegendItem->new({
    insets  => Chart::Clicker::Drawings::Insets->new(),
    label   => 'foo',
    font    => Graphics::Primitive::Font->new()
  });

=head1 METHODS

=head2 new

Creates a new LegendItem object.

=head2 font

Set/Get this legend item's font.

=head2 label

Set/Get this legend item's label.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
