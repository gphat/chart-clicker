package Chart::Clicker::Format::Pdf;
use Moose;

with 'Chart::Clicker::Format';

use Cairo;

sub BUILD {

    die('Your Cairo does not have PDF support!')
        unless Cairo::HAS_PDF_SURFACE;
}

sub create_surface {
    my ($self, $width, $height) = @_;

    return Cairo::ImageSurface->create(
        'argb32', $width, $height
    );
}

sub write {
    my ($self, $click, $file) = @_;
    
    my $surface = Cairo::PdfSurface->create($file, $click->width, $click->height);
    
    my $cr = Chart::Clicker::Context->create($surface);
    $cr->set_source_surface($self->surface, 0, 0);
    $cr->paint();
    $cr->show_page();
    
    $cr = undef;
    $surface = undef;
}

sub data {
    my ($self, $click) = @_;

    my $buff;
    
    my $surface = Cairo::PdfSurface->create_for_stream(sub {
        my ($closure, $data) = @_;
        $buff .= $data;
    }, undef, $click->width, $click->height);
    
    my $cr = Chart::Clicker::Context->create($surface);
    $cr->set_source_surface($self->format->surface, 0, 0);
    $cr->paint();
    $cr->show_page();
    
    $cr = undef;
    $surface = undef;


    return $buff;
}

1;