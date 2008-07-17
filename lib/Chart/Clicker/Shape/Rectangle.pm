package Chart::Clicker::Shape::Rectangle;
use Moose;

extends 'Geometry::Primitive::Rectangle';

with 'Chart::Clicker::Shape';

sub create_path {
    my ($self, $cairo, $x, $y) = @_;

    $cairo->rectangle(
        $x - ($self->width() / 2),
        $y - ($self->height() / 2),
        $self->width(),
        $self->height()
    );

    return 1;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Shape::Rectangle

=head1 DESCRIPTION

Chart::Clicker::Shape::Rectangle represents an rectangle.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Chart::Clicker::Rectangle.

=back

=head2 Instance Methods

=over 4

=item I<create_path>

  $rect->create_path($cairo, $x, $y);

Creates a path using this arcs attributes.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1), L<Geometry::Primitive::Rectangle>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
