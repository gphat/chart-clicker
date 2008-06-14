package Chart::Clicker::Shape::Arc;
use Moose;

extends 'Chart::Clicker::Shape';

has 'angle1' => ( is => 'rw', isa => 'Num' );
has 'angle2' => ( is => 'rw', isa => 'Num' );
has 'radius' => ( is => 'rw', isa => 'Num' );

my $TO_RAD = (4 * atan2(1, 1)) / 180;

sub create_path {
    my $self = shift();
    my ($cairo, $x, $y) = @_;

    my $halfrad = 0;

    $cairo->arc(
        $x + $halfrad, $y + $halfrad, $self->radius(),
        $self->angle1() * $TO_RAD,
        $self->angle2() * $TO_RAD
    );

    return 1;
}

# Convenience method...
sub width {
    my $self = shift();

    return $self->radius();
}

sub height {
    my $self = shift();

    return $self->radius();
}

1;
__END__

=head1 NAME

Chart::Clicker::Shape::Arc

=head1 DESCRIPTION

Chart::Clicker::Shape::Arc represents an arc.

=head1 SYNOPSIS

 use Chart::Clicker::Shape::Arc;

 my $arc = new Chart::Clicker::Shape::Arc({
    angle1 => 0,
    angle2 => 360,
    ragius => 5
 });

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Chart::Clicker::Arc.

=back

=head2 Class Methods

=over 4

=item angle1

Set/Get the starting angle for this arc.

=item angle2

Set/Get the ending angle for this arc.

=item radius

Set/Get the radius for this arc.

=item create_path

  $arc->create_path($cairo, $x, $y);

Creates a path using this arcs attributes.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
