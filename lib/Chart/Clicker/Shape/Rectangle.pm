package Chart::Clicker::Shape::Rectangle;
use Moose;

extends 'Chart::Clicker::Shape';

has 'width' => ( is => 'rw', isa => 'Num' );
has 'height' => ( is => 'rw', isa => 'Num' );

sub create_path {
    my $self = shift();
    my ($cairo, $x, $y) = @_;

    $cairo->rectangle(
        $x - ($self->width() / 2),
        $y - ($self->height() / 2),
        $self->width(),
        $self->height()
    );

    return 1;
}

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

=item new

Creates a new Chart::Clicker::Rectangle.

=back

=head2 Class Methods

=over 4

=item width

Set/Get the width of this rectangle.

=item height

Set/Get the height of this rectangle.

=item create_path

  $rect->create_path($cairo, $x, $y);

Creates a path using this arcs attributes.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
