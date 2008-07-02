package Chart::Clicker::Drawing::Component;
use Moose;

extends 'Graphics::Primitive::Component';

has 'context' => (
    is => 'rw',
    isa => 'Chart::Clicker::Context'
);

1;
__END__

=head1 NAME

Chart::Clicker::Drawing::Component

=head1 DESCRIPTION

A Component is an entity with a graphical representation.

=head1 SYNOPSIS

  my $c = Chart::Clicker::Drawing::Component->new({
    location => Chart::Clicker::Drawing::Point->new({
        x => $x, y => $y
    }),
    width => 500, height => 350
  });

=head1 METHODS

=head2 Constructor

=over 4

=item new

  my $c = Chart::Clicker::Drawing::Component->new({
    location => Chart::Clicker::Drawing::Point->new({
        x => $x, y => $y
    }),
    width => 500, height => 350
  });

Creates a new Component.

=back

=head2 Class Methods

=over 4

=item dimensions

Get this Component's dimensions.

=item draw

Draw this component.

=item inside_width

Get the width available in this container after taking away space for
insets and borders.

=item inside_dimension

Get the dimension of this container's inside.

=item inside_height

Get the height available in this container after taking away space for
insets and borders.

=item height

Set/Get this Component's height

=item location

Set/Get this Component's location

=item width

Set/Get this Component's height

=item upper_left_inside_point

Get the Point for this container's upper left inside.

=item upper_right_inside_point

Get the Point for this container's upper right inside.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
