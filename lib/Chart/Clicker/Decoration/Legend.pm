package Chart::Clicker::Decoration::Legend;
use Moose;

extends 'Chart::Clicker::Decoration';

use Chart::Clicker::Decoration::LegendItem;

use Chart::Clicker::Drawing qw(:positions);
use Chart::Clicker::Drawing::Border;
use Chart::Clicker::Drawing::Font;
use Chart::Clicker::Drawing::Insets;

has 'tallest' => ( is => 'rw', isa => 'Num' );
has 'widest' => ( is => 'rw', isa => 'Num' );

has '+border' => (
    default => sub { new Chart::Clicker::Drawing::Border() }
);

has '+insets' => (
    default => sub {
        new Chart::Clicker::Drawing::Insets(
            top => 3, left => 3, bottom => 3, right => 3
        )
    }
);

has 'item_insets' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Insets',
    default => sub {
        new Chart::Clicker::Drawing::Insets({
            top => 3, left => 3, bottom => 0, right => 0
        })
    }
);

has 'legend_items' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [ ] }
);

has 'font' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Font',
    default => sub {
        new Chart::Clicker::Drawing::Font()
    }
);

has 'orientation' => (
    is => 'rw',
    isa => 'Orientations',
    default => $CC_HORIZONTAL
);

sub prepare {
    my $self = shift();
    my $clicker = shift();
    my $dimension = shift();

    my $ca = $clicker->color_allocator();

    my $font = $self->font();

    my $cr = $clicker->context();
    $cr->save();

    $cr->select_font_face($font->face(), $font->slant(), $font->weight());
    $cr->set_font_size($font->size());

    my $ii = $self->item_insets();

    my $count = 0;
    my $long = 0;
    my $tall = 0;
    my @items;
    foreach my $ds (@{ $clicker->datasets() }) {
        foreach my $s (@{ $ds->series() }) {

            my $label = $s->name();
            unless(defined($label)) {
                $s->name("Series $count");
                $label = "Series $count";
            }
            my $extents = $cr->text_extents($label);
            if($long < $extents->{'width'}) {
                $long = $extents->{'width'};
            }
            if($tall < $extents->{'height'}) {
                $tall = $extents->{'height'};
            }
            push(@items, new Chart::Clicker::Decoration::LegendItem({
                color   => $ca->next(),
                font    => $font,
                insets  => $ii,
                label   => $label
            }));
            $count++;
        }
    }

    $self->widest($long + $ii->left() + $ii->right());
    $self->tallest($tall + $ii->top() + $ii->bottom());

    $self->legend_items(\@items);

    my $per;
    my $insets;
    my $biggest;
    if($self->orientation() == $CC_HORIZONTAL) {
        $biggest = $self->widest();
        # Calculate the maximum width needed for a 'cell'
        $per = ($dimension->width() / $long);
    } else {
        $biggest = $self->tallest();
        # Calculate the maximum height needed for a 'cell'
        $per = ($dimension->height() / $tall);
    }
    if($per < 1) {
        $per = 1;
    }
    my $rows = $count / $per;
    if($rows != int($rows)) {
        $rows = int($rows) + 1;
    }

    $cr->restore();

    if($self->orientation() == $CC_HORIZONTAL) {
        $self->width($dimension->width());
        $self->height(
            # The number of rows we need
            $rows
            # The 'biggest' row (longest or tallest, depending on orientation)
            * $self->tallest()
            # and finally our insets
            + $self->insets->top() + $self->insets->bottom()
            + $self->border->stroke->width() * 2
        );
    } else {
        $self->height($dimension->height());
        $self->width(
            # The number of rows we need
            $rows
            # The 'biggest' row (longest or tallest, depending on orientation)
            * $self->widest()
            # and finally our insets
            + $self->insets->right() + $self->insets->left()
            + $self->border->stroke->width() * 2
        );
    }
    if($self->margins()) {
        my $margins = $self->margins();
        $self->height($self->height() + $margins->top() + $margins->bottom());
        $self->width($self->width() + $margins->left() + $margins->right());
    }

    $ca->reset();

    return 1;
}

sub draw {
    my $self = shift();
    my $clicker = shift();

    my $width = $self->width();
    my $height = $self->height();

    my $surface = $self->SUPER::draw($clicker);
    my $cr = Cairo::Context->create($surface);

    $cr->select_font_face($self->font->face(), $self->font->slant(), $self->font->weight());
    $cr->set_font_size($self->font->size());

    my $mx = 0;
    my $my = 0;
    if(defined($self->margins())) {
        $mx = $self->margins->left();
        $my = $self->margins->top();
    }

    my $x = 0 + $self->insets->left() + $mx;
    # This will break if there are no items...
    # Start at the top + insets...
    my $y = 0 + $my + $self->insets->top();
    foreach my $item (@{ $self->legend_items() }) {

        my $extents = $cr->text_extents($item->label());

        # This item's label might not be as tall as the tallest (or wide as the
        # widest) one we will draw, so we must center this item in the
        # available space.
        my $vcenter = int(($self->tallest() - $extents->{'height'}) / 2);
        my $center = int(($self->widest() - $extents->{'width'}) / 2);

        $cr->move_to($x + $center, $y + $extents->{'height'} + $vcenter);
        $cr->text_path($item->label());
        $cr->set_source_rgba($item->color->rgba());
        $cr->fill();

        # Check to see if we need to wrap
        if(($x + $self->widest()) < $self->inside_width()) {
            # No need to wrap.
            $x += $self->widest();
        } else {
            # Wrap!  Honor insets...
            $x = $self->insets->left();
            $y += $self->tallest();
        }
    }

    return $surface;
}

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

=item new

Creates a new Legend object.

=back

=head2 Class Methods

=over 4

=item border

Set/Get this Legend's border.

=item insets

Set/Get this Legend's insets.

=item prepare

Prepare this Legend by creating the LegendItems based on the datasets
provided and testing the lengths of the series names.

=item draw

Draw this Legend

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
