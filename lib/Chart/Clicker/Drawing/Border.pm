package Chart::Clicker::Drawing::Border;

use Moose;

use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::Stroke;

has 'color' => (
    is => 'rw',
    isa => 'Color',
    default => sub { Chart::Clicker::Drawing::Color->new(
        red     => 0,
        green   => 0,
        blue    => 0,
        alpha   => 1
    ) },
    coerce => 1
);

has 'stroke' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Stroke',
    default => sub { Chart::Clicker::Drawing::Stroke->new(); }
);

1;
__END__

=head1 NAME

Chart::Clicker::Drawing::Border

=head1 DESCRIPTION

Chart::Clicker::Drawing::Border describes the border to be rendered around a
component.

=head1 SYNOPSIS

  use Chart::Clicker::Drawing::Border;

  my $border = Chart::Clicker::Drawing::Border->new({
    color => 'black',
    stroke => Chart::Clicker::Drawing::Stroke->new()
  });

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Chart::Clicker::Border.  Defaults to a color of black and
a default stroke if none are specified.

=back

=head2 Class Methods

=over 4

=item color

Set/Get the Color.

=item stroke

Set/Get the Stroke.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1), L<Chart::Clicker::Drawing::Stroke>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
