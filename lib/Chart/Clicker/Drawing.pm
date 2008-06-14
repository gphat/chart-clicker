package Chart::Clicker::Drawing;
use strict;
use warnings;

use base 'Exporter';

@Chart::Clicker::Drawing::EXPORT_OK = qw(
    $CC_HORIZONTAL $CC_VERTICAL $CC_TOP $CC_BOTTOM $CC_LEFT $CC_RIGHT $CC_CENTER
    $CC_AXIS_TOP $CC_AXIS_BOTTOM $CC_AXIS_LEFT $CC_AXIS_RIGHT
);
%Chart::Clicker::Drawing::EXPORT_TAGS = (
    positions => \@Chart::Clicker::Drawing::EXPORT_OK
);

our $CC_HORIZONTAL = 0;
our $CC_VERTICAL = 1;
our $CC_TOP = 2;
our $CC_BOTTOM = 3;
our $CC_LEFT = 4;
our $CC_RIGHT = 5;
our $CC_CENTER = 6;
our $CC_AXIS_TOP = 7;
our $CC_AXIS_BOTTOM = 8;
our $CC_AXIS_LEFT = 9;
our $CC_AXIS_RIGHT = 10;

1;
__END__

=head1 NAME

Chart::Clicker::Drawing

=head1 DESCRIPTION

Chart::Clicker::Drawing holds some common items used in Drawing.

=head1 SYNOPSIS

  use Chart::Clicker::Drawing qw(:positions);

=head1 EXPORTS

$CC_HORIZONTAL
$CC_VERTICAL
$CC_TOP
$CC_BOTTOM
$CC_LEFT
$CC_RIGHT

=head1 METHODS

=over 4

=back

=head2 Class Methods

=over 4

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
