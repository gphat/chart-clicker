package Chart::Clicker::Format::Svg;
use Moose;

extends 'Chart::Clicker::Format';

use Cairo;

sub BUILD {

    die('Your Cairo does not have SVG support!')
        unless Cairo::HAS_SVG_SURFACE;
}

override('create_surface', sub {
    my ($self, $width, $height) = @_;

    return Cairo::SvgSurface->create_for_stream(
        $self->can('append_surface_data'), $self, $width, $height
    );
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__
=head1 NAME

Chart::Clicker::Format::Svg - SVG Format for Chart::Clicker

=head1 DESCRIPTION

Handles SVG output if your Cairo installation supports SVG

=head1 METHODS

=over 4

=item I<BUILD>

Verifies that Cairo supports this surface type.

=item I<create_surface>

Create a SVG surface

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1), L<Chart::Clicker>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.