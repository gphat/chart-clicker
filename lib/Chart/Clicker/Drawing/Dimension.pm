package Chart::Clicker::Drawing::Dimension;
use Moose;

has 'height' => ( is => 'rw', isa => 'Int' );
has 'width' => ( is => 'rw', isa => 'Int' );

1;
__END__

=head1 NAME

Chart::Clicker::Drawing::Dimension

=head1 DESCRIPTION

Chart::Clicker::Drawing::Dimension represents the width and height of an area.

=head1 SYNOPSIS

  my $dim = new Chart::Clicker::Drawing::Dimension({
    width => 300, height => 300
  });

=head1 METHODS

=head2 Constructor

=over 4

=item new

  my $dim = new Chart::Clicker::Drawing::Dimension({
    width => 300,
    height => 200
  });

Creates a new Chart::Clicker::Drawing::Dimension.

=back

=head2 Class Methods

=over 4

=item height

Set/Get the height of this Dimension

=item width

Set/Get the width of this Dimension

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
