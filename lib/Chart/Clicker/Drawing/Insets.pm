package Chart::Clicker::Drawing::Insets;
use Moose;

has 'top' => ( is => 'rw', isa => 'Num', default => 0 );
has 'bottom' => ( is => 'rw', isa => 'Num', default => 0 );
has 'left' => ( is => 'rw', isa => 'Num', default => 0 );
has 'right' => ( is => 'rw', isa => 'Num', default => 0 );

1;
__END__
=head1 NAME

Chart::Clicker::Drawing::Insets

=head1 DESCRIPTION

Chart::Clicker::Drawing::Insets represents the amount of space a container must
leave at it's edges.

=head1 SYNOPSIS

  use Chart::Clicker::Drawing::Insets;

  my $insets = Chart::Clicker::Drawing::Insets->new({
    top     => $TOP,
    bottom  => $BOTTOM,
    left    => $LEFT,
    right   => $RIGHT
  });

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Chart::Clicker::Drawing::Insets.

=back

=head2 Class Methods

=over 4

=item top

Set/Get the inset from the top.

=item left

Set/Get the inset from the left.

=item right

Set/Get the inset from the right.

=item bottom

Set/Get the inset from the bottom.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
