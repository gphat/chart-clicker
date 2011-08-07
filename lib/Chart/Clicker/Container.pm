package Chart::Clicker::Container;
use Moose;

extends 'Graphics::Primitive::Container';

with 'Graphics::Primitive::Oriented';

# ABSTRACT: Base class that extends Graphics::Primitive::Container

=head1 DESCRIPTION

Chart::Clicker::Container is a subclass of L<Graphics::Primitive::Container>.

=attr clicker

Set/Get this component's clicker object.

=cut

has 'clicker' => (
    is => 'rw',
    isa => 'Chart::Clicker'
);

__PACKAGE__->meta->make_immutable;

no Moose;

1;