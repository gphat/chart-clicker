package Chart::Clicker::Decoration::Legend;
use Moose;

extends 'Chart::Clicker::Container';
with 'Graphics::Primitive::Oriented';

use Chart::Clicker::Decoration::LegendItem;

use Graphics::Primitive::Font;
use Graphics::Primitive::Insets;
use Graphics::Primitive::TextBox;

has '+border' => (
    default => sub {
        Graphics::Primitive::Border->new(
            color => Graphics::Color::RGB->new( red => 0, green => 0, blue => 0),
            width => 1
        )
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
# has '+margins' => ( default => sub {
#     Graphics::Primitive::Insets->new( bottom => 0 )
# });
# has '+padding' => ( default => sub {
#     Graphics::Primitive::Insets->new( top => 0, left => 0, right => 5, bottom => 5)
# });
has 'tallest' => ( is => 'rw', isa => 'Num' );
has 'widest' => ( is => 'rw', isa => 'Num' );

override('prepare', sub {
    my ($self, $driver) = @_;

    my $ca = $self->clicker->color_allocator;

    my $font = $self->font;

    my $ii = $self->item_padding;

    my $count = 0;
    my $long = 0;
    my $tall = 0;
    my @items;
    foreach my $ds (@{ $self->clicker->datasets }) {
        foreach my $s (@{ $ds->series }) {

            my $label = $s->name();
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

    # return 1;
});
# 
# sub dontdraw {
#     my $self = shift();
# 
#     super;
# 
#     my $width = $self->width();
#     my $height = $self->height();
# 
#     my $cr = $self->clicker->cairo();
# 
#     $cr->select_font_face($self->font->face(), $self->font->slant(), $self->font->weight());
#     $cr->set_font_size($self->font->size());
# 
#     my $x = 0;
#     my $y = 0;
#     # If we have padding, honor it.
#     if(defined($self->padding())) {
#         $x = $self->padding->left();
#         $y = $self->padding->top();
#     }
# 
#     foreach my $item (@{ $self->legend_items() }) {
# 
#         my $extents = $cr->text_extents($item->label());
# 
#         # This item's label might not be as tall as the tallest (or wide as the
#         # widest) one we will draw, so we must center this item in the
#         # available space.
#         my $vcenter = ($self->tallest() - $extents->{'height'}) / 2;
#         my $center = ($self->widest() - $extents->{'width'}) / 2;
# 
#         $cr->move_to($x + $center, $y + $extents->{'height'} + $vcenter);
#         $cr->text_path($item->label());
#         $cr->set_source_rgba($item->color->as_array_with_alpha());
#         $cr->fill();
# 
#         # Check to see if we need to wrap
#         if(($x + $self->widest()) < $self->inside_width()) {
#             # No need to wrap.
#             $x += $self->widest();
#         } else {
#             # Wrap!  TODO Honor insets...
#             $x = 0;#$self->insets->left();
#             $y += $self->tallest();
#         }
#     }
# }

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

=head2 Constructor

=over 4

=item I<new>

Creates a new Legend object.

=back

=head2 Instance Methods

=over 4

=item I<border>

Set/Get this Legend's border.

=item I<draw>

Draw this Legend

=item I<font>

Set/Get the font used for this legend's items.

=item I<insets>

Set/Get this Legend's insets.

=item I<item_padding>

Set/Get the padding for this legend's items.

=item I<legend_items>

Set/Get this legend's items.

=item I<prepare>

Prepare this Legend by creating the LegendItems based on the datasets
provided and testing the lengths of the series names.

=item I<tallest>

Set/Get the height of the tallest label.

=item I<widest>

Set/Get the width of the widest label.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
