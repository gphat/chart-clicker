package Chart::Clicker::Format::Svg;
use Moose;

with 'Chart::Clicker::Format';

use Cairo;

sub BUILD {

    die('Your Cairo does not have PostScript support!')
        unless Cairo::HAS_PS_SURFACE;
}

sub create_surface {
    my ($self, $width, $height) = @_;
    
    return Cairo::SvgSurface->create_for_stream(sub { }, undef, $width, $height);
}

sub write {
    my ($self, $click, $file) = @_;
    
    my $surface = Cairo::SvgSurface->create($file, $click->width, $click->height);

    my $cr = Chart::Clicker::Context->create($surface);
    $cr->set_source_surface($self->surface, 0, 0);
    $cr->paint();
    $cr->show_page();

    # Unset the context and the surface to force them to do the actual drawing.
    $cr = undef;
    $surface = undef;
}

sub data {
    my ($self, $click) = @_;

    my $buff;
    
    my $surface = Cairo::SvgSurface->create_for_stream(sub {
        my ($closure, $data) = @_;
        $buff .= $data;
    }, undef, $click->width, $click->height);

    my $cr = Chart::Clicker::Context->create($surface);
    $cr->set_source_surface($self->surface, 0, 0);
    $cr->paint();
    $cr->show_page();

    $cr = undef;
    $surface = undef;


    return $buff;
}

1;