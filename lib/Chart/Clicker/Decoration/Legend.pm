package Chart::Clicker::Decoration::Legend;
use Moose;

extends 'Chart::Clicker::Container';
with 'Graphics::Primitive::Oriented';

# ABSTRACT: Series name, color key

use Graphics::Primitive::Font;
use Graphics::Primitive::Insets;
use Graphics::Primitive::TextBox;

use Layout::Manager::Flow;

=head1 DESCRIPTION

Chart::Clicker::Decoration::Legend draws a legend on a Chart.

=attr border

Set/Get this Legend's L<border|Graphics::Primitive::Border>.
=cut

has '+border' => (
    default => sub {
        my $b = Graphics::Primitive::Border->new;
        $b->color(Graphics::Color::RGB->new( red => 0, green => 0, blue => 0));
        $b->width(1);
        return $b;
    }
);

=attr font

Set/Get the L<font|Graphics::Primitive::Font> used for this legend's items.

=cut

has 'font' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Font',
    default => sub {
        Graphics::Primitive::Font->new
    }
);

=attr insets

Set/Get this Legend's L<insets|Graphics::Primitive::Insets>.

=attr item_padding

Set/Get the L<padding|Graphics::Primitive::Insets> for this legend's items.

=cut

has 'item_padding' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Insets',
    default => sub {
        Graphics::Primitive::Insets->new({
            top => 3, left => 3, bottom => 3, right => 5
        })
    }
);

=attr layout_manager

Set/Get the layout manager for this lagend.  Defaults to
L<Layout::Manager::Flow> with an anchor of C<west> and a C<wrap> of 1.

=cut

has '+layout_manager' => (
    default => sub { Layout::Manager::Flow->new(anchor => 'west', wrap => 1) },
    lazy => 1
);

override('prepare', sub {
    my ($self, $driver) = @_;

    return if $self->component_count > 0;

    my $ca = $self->clicker->color_allocator;

    my $font = $self->font;

    my $ii = $self->item_padding;
    
    #this makes sure that wrapping works
    $self->width($self->clicker->width);

    if($self->is_vertical) {
        # This assumes you aren't changing the layout manager...
        $self->layout_manager->anchor('north');
    }

    my $count = 0;
    foreach my $ds (@{ $self->clicker->datasets }) {
        foreach my $s (@{ $ds->series }) {

            unless($s->has_name) {
                $s->name("Series $count");
            }

            my $tb = Graphics::Primitive::TextBox->new(
                color => $ca->next,
                font => $font,
                padding => $ii,
                text => $s->name
            );

            $self->add_component($tb);

            $count++;
        }
    }

    super;

    $ca->reset;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
