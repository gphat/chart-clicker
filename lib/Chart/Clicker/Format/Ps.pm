package Chart::Clicker::Format::Ps;
use Moose;

with 'Chart::Clicker::Format';

use Cairo;

sub BUILD {

    die('Your Cairo does not have PostScript support!')
        unless Cairo::HAS_PS_SURFACE;
}

sub create_surface {
    my ($self, $width, $height) = @_;

    return Cairo::PsSurface->create_for_stream(
        $self->can('append_surface_data'), $self, $width, $height
    );
}

1;