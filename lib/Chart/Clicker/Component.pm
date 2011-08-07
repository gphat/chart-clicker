package Chart::Clicker::Component;
use Moose;

extends 'Graphics::Primitive::Component';

with 'Graphics::Primitive::Oriented';

# ABSTRACT: Base class that extends Graphics::Primitive::Component

=head1 DESCRIPTION

Chart::Clicker::Component is a subclass of L<Graphics::Primitive::Component>.

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