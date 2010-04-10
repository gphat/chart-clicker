package Chart::Clicker::Component;
use Moose;

extends 'Graphics::Primitive::Component';

with 'Graphics::Primitive::Oriented';

has 'clicker' => (
    is => 'rw',
    isa => 'Chart::Clicker'
);

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Component - Base class that extends Graphics::Primitive::Component

=head1 DESCRIPTION

Chart::Clicker::Component is a subclass of L<Graphics::Primitive::Component>.

=head1 SYNOPSIS

=head1 ATTRIBUTES

=head2 clicker

Set/Get this component's clicker object.

=head1 METHODS

=head2 new

Creates a new Chart::Clicker::Component

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
