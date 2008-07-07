package Chart::Clicker::Drawing::Container;
use Moose;
use MooseX::AttributeHelpers;

extends 'Graphics::Primitive::Container';

no Moose;

1;
__END__
=head1 NAME

Chart::Clicker::Drawing::Container

=head1 DESCRIPTION

A Base 'container' for all components that want to hold other components.

=head1 SYNOPSIS

  my $c = Chart::Clicker::Drawing::Container->new({
    width => 500, height => 350
    background_color => 'white',
    border => Chart::Clicker::Drawing::Border->new(),
    insets => Chart::Clicker::Drawing::Insets->new(),
  });

=cut

=head1 METHODS

=head2 Constructor

=over 4

=item new

  my $c = Chart::Clicker::Drawing::Container->new({
    width => 500, height => 350
    background_color => 'white',
    border => Chart::Clicker::Drawing::Border->new(),
    insets => Chart::Clicker::Drawing::Insets->new(),
  });

Creates a new Container.  Width and height must be specified.  Border,
background_color and insets are all optional and will default to undef

=back

=head2 Class Methods

=over 4

=item background_color

Set/Get this Container's background color.

=item border

Set/Get this Container's border

=item components

Get the components in this container. The return value is an arrayref of
hashrefs.  Each hashref has a 'component' and 'position' key.

=item draw

Draw this container and all of it's children.

=item height

Set/Get this Container's height

=item insets

Set/Get this Container's insets.

=item prepare

Prepare this container for rendering.  All of it's child components will be
prepared as well.

=item add

Add a component to this container.

  $cont1->add($foo);
  $cont2->add($cont1, $CC_TOP);
  $cont2->add($cont1, $CC_TOP, 1);

The first argument must be some other entity that is renderable by
Chart::Clicker.  The second argument is an optional position.  The positioning
of elements is very rudimentary.  If you do not specify a position then
$CC_CENTER is used.  The third argument is a flag that controls whether this
component will actually affect the layout of items after it.  This is used
to make renderers render 'over' each other.  A normal use of this would be
to stack the Grid and Renderer.

=cut

=item width

Set/Get this Container's height

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
