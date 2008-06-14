package Chart::Clicker::Drawing::Font;
use Moose;
use Moose::Util::TypeConstraints;

use Exporter 'import';

@Chart::Clicker::Drawing::Font::EXPORT_OK = qw(
    $CC_FONT_SLANT_NORMAL $CC_FONT_SLANT_ITALIC $CC_FONT_SLANT_OBLIQUE
    $CC_FONT_WEIGHT_NORMAL $CC_FONT_WEIGHT_BOLD
);
%Chart::Clicker::Drawing::Font::EXPORT_TAGS = (
    slants => [ qw(
        $CC_FONT_SLANT_NORMAL $CC_FONT_SLANT_ITALIC $CC_FONT_SLANT_OBLIQUE
    ) ],
    weights => [ qw(
        $CC_FONT_WEIGHT_NORMAL $CC_FONT_WEIGHT_BOLD
    ) ]
);

our $CC_FONT_SLANT_NORMAL = 'normal';
our $CC_FONT_SLANT_ITALIC = 'italic';
our $CC_FONT_SLANT_OBLIQUE = 'oblique';

enum 'Slants' => (
    $CC_FONT_SLANT_NORMAL, $CC_FONT_SLANT_ITALIC, $CC_FONT_SLANT_OBLIQUE
);

our $CC_FONT_WEIGHT_NORMAL = 'normal';
our $CC_FONT_WEIGHT_BOLD = 'bold';

enum 'Weights' => (
    $CC_FONT_WEIGHT_NORMAL, $CC_FONT_WEIGHT_BOLD
);

has 'face' => (
    is => 'rw',
    isa => 'Str',
    default => 'Sans'
);

has 'size' => (
    is => 'rw',
    isa => 'Num',
    default => 12
);

has 'slant' => (
    is => 'rw',
    isa => 'Str',
    default => $CC_FONT_SLANT_NORMAL
);

has 'weight' => (
    is => 'rw',
    isa => 'Str',
    default => $CC_FONT_WEIGHT_NORMAL
);

1;
__END__
=head1 NAME

Chart::Clicker::Drawing::Font

=head1 DESCRIPTION

Chart::Clicker::Drawing::Font represents the various options that are available
when rendering text on the chart.

=head1 EXPORTS

$CC_FONT_SLANT_NORMAL
$CC_FONT_SLANT_ITALIC
$CC_FONT_SLANT_OBLIQUE

$CC_FONT_WEIGHT_NORMAL
$CC_FONT_WEIGHT_BOLD

=head1 SYNOPSIS

  use Chart::Clicker::Drawing::Font;

  my $font = new Chart::Clicker::Drawing::Font({
    face => 'Sans',
    size => 12,
    slant => $Chart::Clicker::Drawing::FONT_SLANT_NORMAL
  });

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Chart::Clicker::Decoration::Font.

=back

=head2 Class Methods

=over 4

=item size

Set/Get the size of this text.

=item slant

Set/Get the slant of this text.

=item weight

Set/Get the weight of this text.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
