package Chart::Clicker::Format::Pdf;
use Moose;

extends 'Chart::Clicker::Format';

use Cairo;

sub BUILD {
    my $self = @_;

    die('Your Cairo does not have PDF support!')
        unless Cairo::HAS_PDF_SURFACE;
}

override('create_surface', sub {
    my ($self, $width, $height) = @_;

    return Cairo::PdfSurface->create_for_stream(
        $self->can('append_surface_data'), $self, $width, $height
    );
});

no Moose;

1;
__END__
=head1 NAME

Chart::Clicker::Format::Pdf - PDF Format for Chart::Clicker

=head1 DESCRIPTION

Handles PDF output if your Cairo installation supports PDF

=head1 METHODS

=over 4

=item I<BUILD>

Verifies that Cairo supports this surface type.

=item I<create_surface>

Create a PDF surface

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1), L<Chart::Clicker>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.