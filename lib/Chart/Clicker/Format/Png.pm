package Chart::Clicker::Format::Png;
use Moose;

with 'Chart::Clicker::Format';

use Cairo;

sub create_surface {
    my ($self, $width, $height) = @_;

    return Cairo::ImageSurface->create(
        'argb32', $width, $height
    );
}

sub write {
    my ($self, $click, $file) = @_;

    $self->surface->write_to_png($file);
}

sub data {
    my ($self, $click) = @_;

    my $buff;
    $self->surface->write_to_png_stream(sub {
        my ($closure, $data) = @_;
        $buff .= $data;
    });

    return $buff;
}

1;