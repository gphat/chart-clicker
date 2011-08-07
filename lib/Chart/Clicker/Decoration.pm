package Chart::Clicker::Decoration;
use Moose;

# ABSTRACT: Shiny baubles!

extends 'Graphics::Primitive::Canvas';

=head1 DESCRIPTION

Chart::Clicker::Decoration is a straight subclass of
L<Graphics::Primitive::Canvas>.

=cut

has 'clicker' => ( is => 'rw', isa => 'Chart::Clicker' );

__PACKAGE__->meta->make_immutable;

no Moose;

1;