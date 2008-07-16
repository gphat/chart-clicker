package Chart::Clicker::Format::Png;
use Moose;

extends 'Chart::Clicker::Format';

use Cairo;

override('create_surface', sub {
    my ($self, $width, $height) = @_;

    return Cairo::ImageSurface->create('argb32', $width, $height);
});

override('write', sub {
    my ($self, $click, $file) = @_;

    $click->cairo->get_target->write_to_png($file);
});

no Moose;

1;
__END__
=head1 NAME

Chart::Clicker::Format::Png - PNG Format for Chart::Clicker

=head1 DESCRIPTION

Handles PNG output if your Cairo installation supports PNG

=head1 METHODS

=over 4

=item I<BUILD>

Verifies that Cairo supports this surface type.

=item I<create_surface>

Create a PNG surface

=item I<write>

Override's L<Chart::Clicker::Format>'s I<write> method.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1), L<Chart::Clicker>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.