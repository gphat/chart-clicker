package Chart::Clicker::Decoration::Legend;
use Moose;

extends 'Chart::Clicker::Container';
with 'Graphics::Primitive::Oriented';

# TODO Move me out of decoration

use Chart::Clicker::Decoration::LegendItem;

use Graphics::Primitive::Font;
use Graphics::Primitive::Insets;
use Graphics::Primitive::TextBox;

has '+border' => (
    default => sub {
        my $b = Graphics::Primitive::Border->new;
        $b->color(Graphics::Color::RGB->new( red => 0, green => 0, blue => 0));
        $b->width(1);
        return $b;
    }
);
has 'font' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Font',
    default => sub {
        Graphics::Primitive::Font->new
    }
);
has 'item_padding' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Insets',
    default => sub {
        Graphics::Primitive::Insets->new({
            top => 3, left => 3, bottom => 3, right => 5
        })
    }
);
has '+layout_manager' => (
    default => sub { Layout::Manager::Compass->new }
);
has 'tallest' => ( is => 'rw', isa => 'Num' );
has 'widest' => ( is => 'rw', isa => 'Num' );

override('prepare', sub {
    my ($self, $driver) = @_;

    return if $self->component_count > 0;

    my $ca = $self->clicker->color_allocator;

    my $font = $self->font;

    my $ii = $self->item_padding;

    my $count = 0;
    my $long = 0;
    my $tall = 0;
    my @items;
    foreach my $ds (@{ $self->clicker->datasets }) {
        foreach my $s (@{ $ds->series }) {

            my $label = $s->name;
            unless(defined($label)) {
                $s->name("Series $count");
                $label = "Series $count";
            }

            my $tb = Graphics::Primitive::TextBox->new(
                color => $ca->next,
                font => $self->font,
                padding => $self->item_padding,
                text => $label
            );

            # Add this to the container in the right direction based on
            # our orientation
            my $dir = 'w';
            if($self->is_vertical) {
                $dir = 'n';
            }

            $self->add_component($tb, $dir);

            $count++;
        }
    }

    super;

    $ca->reset;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::Legend

=head1 DESCRIPTION

Chart::Clicker::Decoration::Legend draws a legend on a Chart.

=head1 SYNOPSIS

=head1 METHODS

=head2 new

Creates a new Legend object.

=head2 border

Set/Get this Legend's border.

=head2 draw

Draw this Legend

=head2 font

Set/Get the font used for this legend's items.

=head2 insets

Set/Get this Legend's insets.

=head2 item_padding

Set/Get the padding for this legend's items.

=head2 legend_items

Set/Get this legend's items.

=head2 prepare

Prepare this Legend by creating the LegendItems based on the datasets
provided and testing the lengths of the series names.

=head2 tallest

Set/Get the height of the tallest label.

=head2 widest

Set/Get the width of the widest label.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
