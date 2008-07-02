package Chart::Clicker::Format::Pdf;
use Moose;

with 'Chart::Clicker::Format';

use Cairo;

sub BUILD {
    my $self = @_;

    die('Your Cairo does not have PDF support!')
        unless Cairo::HAS_PDF_SURFACE;
}

sub create_surface {
    my ($self, $width, $height) = @_;

    print STDERR "WEEE\n";

    return Cairo::PdfSurface->create_for_stream(
        $self->can('append_surface_data'), $self, $width, $height
    );
}

1;