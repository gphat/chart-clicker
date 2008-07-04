package Chart::Clicker::Format::Png;
use Moose;

with 'Chart::Clicker::Format';

use Cairo;

sub create_surface {
    my ($self, $width, $height) = @_;

    return Cairo::ImageSurface->create('argb32', $width, $height);
}

sub write {
    my ($self, $click, $file) = @_;

    $click->cairo->get_target->write_to_png($file);
}

no Moose;

1;