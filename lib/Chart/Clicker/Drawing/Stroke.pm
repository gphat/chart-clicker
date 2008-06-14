package Chart::Clicker::Drawing::Stroke;

use Moose;
use Moose::Util::TypeConstraints;

@Chart::Clicker::Drawing::Stroke::EXPORT_OK = qw(
  $CC_LINE_CAP_BUTT $CC_LINE_CAP_ROUND $CC_LINE_CAP_SQUARE
  $CC_LINE_JOIN_MITER $CC_LINE_JOIN_ROUND $CC_LINE_JOIN_BEVEL
);
%Chart::Clicker::Drawing::Stroke::EXPORT_TAGS = (
    line_caps => [ qw(
        $CC_LINE_CAP_BUTT $CC_LINE_CAP_ROUND $CC_LINE_CAP_SQUARE
    ) ],
    line_joins => [ qw(
        $CC_LINE_JOIN_MITER $CC_LINE_JOIN_ROUND $CC_LINE_JOIN_BEVEL
    ) ],
);

our $CC_LINE_CAP_BUTT = 'butt';
our $CC_LINE_CAP_ROUND = 'round';
our $CC_LINE_CAP_SQUARE = 'square';

our $CC_LINE_JOIN_MITER = 'miter';
our $CC_LINE_JOIN_ROUND = 'round';
our $CC_LINE_JOIN_BEVEL = 'bevel';

enum 'LineCap' => ($CC_LINE_CAP_BUTT, $CC_LINE_CAP_ROUND, $CC_LINE_CAP_SQUARE);
enum 'LineJoin' => ($CC_LINE_JOIN_MITER, $CC_LINE_JOIN_ROUND, $CC_LINE_JOIN_BEVEL);

has 'width' => ( is => 'rw', isa => 'Int', default => 1 );
has 'line_cap' => ( is => 'rw', isa => 'LineCap', default => $CC_LINE_CAP_BUTT );
has 'line_join' => ( is => 'rw', isa => 'LineJoin', default => $CC_LINE_JOIN_MITER );

1;
__END__

=head1 NAME

Chart::Clicker::Drawing::Stroke

=head1 DESCRIPTION

Chart::Clicker::Drawing::Stroke represents the decorative outline around a component.
Since a line is infinitely small, we need some sort of outline to be able to
see it!

=head1 SYNOPSIS

  use Chart::Clicker::Drawing::Stroke qw(:line_caps :line_joins);

  my $stroke = new Chart::Clicker::Drawing::Stroke({
    line_cap => $CC_LINE_CAP_ROUND,
    line_join => $CC_LINE_JOIN_MITER,
    width => 2
  });

=head1 EXPORTS

$CC_LINE_CAP_BUTT
$CC_LINE_CAP_ROUND
$CC_LINE_CAP_SQUARE

$CC_LINE_JOIN_MITER
$CC_LINE_JOIN_ROUND
$CC_LINE_JOIN_BEVEL

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Chart::Clicker::Decoration::Stroke.  If no options are provided
the width defaults to 1, the line_cap defaults to $CC_LINE_CAP_BUTT and the
line_join defaults to $CC_LINE_JOIN_MITER.

=back

=head2 Class Methods

=over 4

=item line_cap

Set/Get the line_cap of this stroke.

=item line_join

Set/Get the line_join of this stroke.

=item width

Set/Get the width of this stroke.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
