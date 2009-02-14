package Chart::Clicker::Decoration;
use Moose;

extends 'Graphics::Primitive::Canvas';

has 'clicker' => ( is => 'rw', isa => 'Chart::Clicker' );

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Decoration

=head1 DESCRIPTION

Chart::Clicker::Decoration is a straight subclass of
L<Graphics::Primitive::Canvas>.

=head1 SYNOPSIS

=head1 METHODS

=head2 new

Creates a new Chart::Clicker::Decoration

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
