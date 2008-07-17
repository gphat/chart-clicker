package Chart::Clicker::Shape::Arc;
use Moose;

extends 'Geometry::Primitive::Arc';

with 'Chart::Clicker::Shape';

use Geometry::Primitive::Util;

sub create_path {
    my ($self, $cairo, $x, $y) = @_;

    my $halfrad = 0;

    $cairo->arc(
        $x + $halfrad, $y + $halfrad, $self->radius,
        Geometry::Primitive::Util->degrees_to_radians($self->angle_start),
        Geometry::Primitive::Util->degrees_to_radians($self->angle_end)
    );

    return 1;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Shape::Arc

=head1 DESCRIPTION

Chart::Clicker::Shape::Arc represents an arc.

=head1 SYNOPSIS

 use Chart::Clicker::Shape::Arc;

 my $arc = Chart::Clicker::Shape::Arc->new({
    angle_start => 0,
    angle_end => 360,
    ragius => 5
 });

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Chart::Clicker::Arc.

=back

=head2 Instance Methods

=over 4

=item I<create_path>

  $arc->create_path($cairo, $x, $y);

Creates a path using this arcs attributes.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1), L<Geometry::Primitive::Arc>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
