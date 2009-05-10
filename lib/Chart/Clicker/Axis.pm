package Chart::Clicker::Axis;
use Moose;

extends 'Chart::Clicker::Container';
with 'Chart::Clicker::Positioned';

use Chart::Clicker::Data::Range;

use Graphics::Color::RGB;

use Graphics::Primitive::Font;

use Layout::Manager::Absolute;

use Math::Trig ':pi';

use Moose::Util::TypeConstraints;
use MooseX::AttributeHelpers;

type 'StrOrCodeRef' => where { (ref($_) eq "") || ref($_) eq 'CODE' };

has 'tick_label_angle' => (
    is => 'rw',
    isa => 'Num'
);
has 'baseline' => (
    is  => 'rw',
    isa => 'Num',
);
# Remove for border...
has 'brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub {
        Graphics::Primitive::Brush->new(
            color => Graphics::Color::RGB->new(
                red => 1, green => 0, blue => 1, alpha => 1
            ),
            width => 1
        )
    }
);
has '+color' => (
    default => sub {
        Graphics::Color::RGB->new({
            red => 0, green => 0, blue => 0, alpha => 1
        })
    }
);
has 'format' => ( is => 'rw', isa => 'StrOrCodeRef' );
has 'fudge_amount' => ( is => 'rw', isa => 'Num', default => 0 );
has 'hidden' => ( is => 'rw', isa => 'Bool', default => 0 );
has 'label' => ( is => 'rw', isa => 'Str' );
has 'label_color' => (
    is => 'rw',
    isa => 'Graphics::Color',
    default => sub {
        Graphics::Color::RGB->new({
            red => 0, green => 0, blue => 0, alpha => 1
        })
    }
);
has 'label_font' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Font',
    default => sub { Graphics::Primitive::Font->new }
);
has '+layout_manager' => ( default => sub { Layout::Manager::Absolute->new });
has '+orientation' => (
    required => 1
);
has '+position' => (
    required => 1
);
has 'range' => (
    is => 'rw',
    isa => 'Chart::Clicker::Data::Range',
    default => sub { Chart::Clicker::Data::Range->new }
);
has 'show_ticks' => ( is => 'rw', isa => 'Bool', default => 1 );
has 'staggered' => ( is => 'rw', isa => 'Bool', default => 0 );
has 'tick_brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub { Graphics::Primitive::Brush->new }
);
has 'tick_font' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Font',
    default => sub { Graphics::Primitive::Font->new }
);
has 'tick_label_color' => (
    is => 'rw',
    isa => 'Graphics::Color',
    default => sub {
        Graphics::Color::RGB->new({
            red => 0, green => 0, blue => 0, alpha => 1
        })
    }
);
has 'tick_labels' => (
    is => 'rw',
    isa => 'ArrayRef',
);
has 'tick_length' => ( is => 'rw', isa => 'Num', default => 3 );
has 'tick_values' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        'push' => 'add_to_tick_values',
        'clear' => 'clear_tick_values',
        'count' => 'tick_value_count'
    }
);
has 'ticks' => ( is => 'rw', isa => 'Int', default => 5 );

sub BUILD {
    my ($self) = @_;

    $self->padding(3);
}

override('prepare', sub {
    my ($self, $driver) = @_;

    $self->clear_components;

    # The BUILD method above establishes a 5px padding at instantiation time.
    # That saves us setting it elsewhere, but if 'hidden' feature is used,
    # then we have to unset the padding.  hidden (as explained below) is
    # basically a hack as far as G:P is concerned to render an empty Axis.
    # We want it to render because we need it prepared for other elements
    # of the chart to work.
    if($self->hidden) {
        $self->padding(0);
        # Hide the border too, jic
        $self->border->width(0);
    }

    super;

    if($self->range->span == 0) {
        die('This axis has a span of 0, that\'s fatal!');
    }

    if(defined($self->baseline)) {
        if($self->range->lower > $self->baseline) {
            $self->range->lower($self->baseline);
        }
    } else {
        $self->baseline($self->range->lower);
    }

    if($self->fudge_amount) {
        my $span = $self->range->span;
        my $lower = $self->range->lower;
        $self->range->lower($lower - abs($span * $self->fudge_amount));
        my $upper = $self->range->upper;
        $self->range->upper($upper + ($span * $self->fudge_amount));
    }

    if(!scalar(@{ $self->tick_values })) {
        $self->tick_values($self->range->divvy($self->ticks + 1));
    }

    # Return now without setting a min height or width and allow 
    # Layout::Manager to to set it for us, this is how we 'hide'
    return if $self->hidden;

    my $tfont = $self->tick_font;

    my $bheight = 0;
    my $bwidth = 0;

    # Determine all this once... much faster.
    my $i = 0;
    foreach my $val (@{ $self->tick_values }) {
        my $label = $val;
        if(defined($self->tick_labels)) {
            $label = $self->tick_labels->[$i];
        } else {
            $label = $self->format_value($val);
        }

        my $tlabel = Graphics::Primitive::TextBox->new(
            text => $label,
            font => $tfont,
            color => $self->tick_label_color,
        );
        if($self->tick_label_angle) {
            $tlabel->angle($self->tick_label_angle);
        }
        my $lay = $driver->get_textbox_layout($tlabel);

        $tlabel->prepare($driver);

        $tlabel->width($lay->width);
        $tlabel->height($lay->height);

        $bwidth = $tlabel->width if($tlabel->width > $bwidth);
        $bheight = $tlabel->height if($tlabel->height > $bheight);

        $self->add_component($tlabel);
        $i++;
    }

    my $big = $bheight;
    if($self->is_vertical) {
        $big = $bwidth;
    }

    if($self->show_ticks) {
        $big += $self->tick_length;
    }

    my $label_width = 0;
    my $label_height = 0;

    if ($self->label) {

        my $label = Graphics::Primitive::TextBox->new(
            # angle => $angle,
            color => $self->label_color,
            name => 'label',
            font => $self->label_font,
            text => $self->label,
            width => $self->height
        );

        if($self->is_vertical) {
            if ($self->is_left) {
                $label->angle(-&pip2);
            } else {
                $label->angle(&pip2)
            }
        }


        $label->prepare($driver);

        $label->width($label->minimum_width);
        $label->height($label->minimum_height);

        $label_width = $label->width;
        $label_height = $label->height;
        $self->add_component($label);
    }

    if($self->is_vertical) {
        $self->minimum_width($self->outside_width + $big + $label_width);
        $self->minimum_height($self->outside_height + $self->outside_height + $big);
    } else {
        $self->minimum_height($self->outside_height + $big + $label_height);
        $self->minimum_width($self->outside_width + $big + $self->outside_width);
        if($self->staggered) {
            $self->minimum_height($self->minimum_height * 2);
        }
    }

    return 1;
});

sub mark {
    my ($self, $span, $value) = @_;

    # 'caching' this here speeds things up.  Calling after changing the
    # range would result in a messed up chart anyway...
    if(!defined($self->{LOWER})) {
        $self->{LOWER} = $self->range->lower;
        $self->{RSPAN} = $self->range->span - 1;
        if($self->{RSPAN} < 1) {
            $self->{RSPAN} = 1;
        }
    }

    return ($span / $self->{RSPAN}) * ($value - $self->{LOWER} || 0);
}

override('finalize', sub {
    my ($self) = @_;

    super;

    return if $self->hidden;

    my $x = 0;
    my $y = 0;

    my $width = $self->width;
    my $height = $self->height;
    my $ibb = $self->inside_bounding_box;
    my $iox = $ibb->origin->x;
    my $ioy = $ibb->origin->y;

    my $iwidth = $ibb->width;
    my $iheight = $ibb->height;

    if($self->is_left) {
        $x += $width;
    } elsif($self->is_right) {
        # nuffin
    } elsif($self->is_top) {
        $y += $height;
    } else {
        # nuffin
    }

    my $tick_length = $self->tick_length;

    my $lower = $self->range->lower;

    my @values = @{ $self->tick_values };

    if($self->is_vertical) {

        for(0..scalar(@values) - 1) {
            my $val = $values[$_];
            my $iy = $height - $self->mark($height, $val);
            my $label = $self->get_component($_);

            if($self->is_left) {
                $label->origin->x($iox + $iwidth - $label->width);
                $label->origin->y($iy - ($label->height / 2));
            } else {
                $label->origin->x($iox);
                $label->origin->y($iy - ($label->height / 2));
            }
        }

        # Draw the label
        # FIXME Not working, rotated text labels...
        if($self->label) {
            my $label = $self->get_component($self->find_component('label'));

            if($self->is_left) {

                $label->origin->x($iox);
                $label->origin->y(($height - $label->height) / 2);
            } else {

                $label->origin->x($iox + $iwidth - $label->width);
                $label->origin->y(($height - $label->height) / 2);
            }
        }
    } else {
        # Draw a tick for each value.
        for(0..scalar(@values) - 1) {
            my $val = $values[$_];
            my $ix = $self->mark($width, $val);

            my $label = $self->get_component($_);

            my $bump = 0;
            if($self->staggered) {
                if($_ % 2) {
                    $bump = $iheight / 2;
                }
            }

            if($self->is_top) {

                $label->origin->x($ix - ($label->width / 1.8));
                $label->origin->y($ioy + $iheight - $label->height - $bump);
            } else {
                $label->origin->x($ix - ($label->width / 1.8));
                $label->origin->y($ioy + $bump);
            }
        }

        # Draw the label
        # FIXME Not working, rotated text labels...
        if($self->label) {
            my $label = $self->get_component($self->find_component('label'));

            my $ext = $self->{'label_extents_cache'};
            if ($self->is_bottom) {
                $label->origin->x(($width - $label->width) / 2);
                $label->origin->y($height - $label->height
                    - ($self->padding->bottom + $self->margins->bottom
                        + $self->border->top->width
                    )
                );
            } else {
                $label->origin->x(($width - $label->width) / 2);
            }
        }
    }
});

sub format_value {
    my $self = shift;
    my $value = shift;

    my $format = $self->format;
    if($format) {
        if(ref($format) eq 'CODE') {
            return &$format($value);
        } else {
            return sprintf($format, $value);
        }

    }
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Axis

=head1 DESCRIPTION

Chart::Clicker::Axis represents the plot of the chart.

=head1 SYNOPSIS

  use Chart::Clicker::Axis;
  use Graphics::Primitive::Font;
  use Graphics::Primitive::Brush;

  my $axis = Chart::Clicker::Axis->new({
    font  => Graphics::Primitive::Font->new,
    orientation => 'vertical',
    position => 'left',
    brush = Graphics::Primitive::Brush->new,
    tick_length => 2,
    tick_brush => Graphics::Primitive::Brush->new,
    visible => 1,
  });

=head1 METHODS

=head2 new

Creates a new Chart::Clicker::Axis.  If no arguments are given then sane
defaults are chosen.

=head2 baseline

Set the 'baseline' value of this axis.  This is used by some renderers to
change the way a value is marked.  The Bar render, for instance, considers
values below the base to be 'negative'.

=head2 brush

Set/Get the brush for this axis.

=head2 color

Set/Get the color of the axis' border.

=head2 format

Set/Get the format to use for the axis values.

If the format is a string then format is applied to each value 'tick' via
sprintf.  See sprintf perldoc for details!  This is useful for situations
where the values end up with repeating decimals.

If the format is a coderef then that coderef will be executed and the value
passed to it as an argument.

  my $nf = Number::Format->new;
  $default->domain_axis->format(sub { return $nf->format_number(shift); });

=head2 fudge_amount

Set/Get the amount to 'fudge' the span of this axis.  You should supply a
percentage (in decimal form) and the axis will grow at both ends by the
supplied amount.  This is useful when you want a bit of padding above and
below the dataset.

As an example, a fugdge_amount of .10 on an axis with a span of 10 to 50
would add 5 to the top and bottom of the axis.

=head2 height

Set/Get the height of the axis.

=head2 label

Set/Get the label of the axis.

=head2 label_color

Set the color of the Axis' labels.

=head2 label_font

Set/Get the font used for the axis' label.


=head2 orientation

Set/Get the orientation of this axis.  See L<Chart::Clicker::Drawing>.

=head2 position

Set/Get the position of the axis on the chart.

=head2 range

Set/Get the Range for this axis.

=head2 show_ticks

Set/Get the show ticks flag.  If this is value then the small tick marks at
each mark on the axis will not be drawn.

=head2 tick_font

Set/Get the font used for the axis' ticks.

=head2 tick_label_angle

Set the angle (in radians) to rotate the tick's labels.

=head2 tick_label_color

Set the color of the tick labels.

=head2 tick_length

Set/Get the tick length.

=head2 tick_values

Set/Get the arrayref of values show as ticks on this Axis.

=head2 add_to_tick_values

Add a value to the list of tick values.

=head2 clear_tick_values

Clear all tick values.

=head2 stagger

Set/Get the stagger flag, which causes horizontally labeled axes to 'stagger'
the labels so that half are at the top of the box and the other half are at
the bottom.  This makes long, overlapping labels less likely to overlap.  It
only does something useful with B<horizontal> labels.

=head2 tick_brush

Set/Get the stroke for the tick markers.

=head2 tick_value_count

Get a count of tick values.

=head2 tick_labels

Set/Get the arrayref of labels to show for ticks on this Axis.  This arrayref
is consulted for every tick, in order.  So placing a string at the zeroeth
index will result in it being displayed on the zeroeth tick, etc, etc.

=head2 ticks

Set/Get the number of 'ticks' to show.  Setting this will divide the
range on this axis by the specified value to establish tick values.  This
will have no effect if you specify tick_values.

=head2 mark

Given a span and a value, returns it's pixel position on this Axis.

=head2 format_value

Given a value, returns it formatted using this Axis' formatter.

=head2 prepare

Prepare this Axis by determining the size required.  If the orientation is
CC_HORIZONTAL this method sets the height.  Otherwise sets the width.

=head2 draw

Draw this axis.

=head2 hidden

Set/Get this axis' hidden flag.

=head2 width

Set/Get this axis' width.

=head2 BUILD

Documening for POD::Coverage tests, Moose stuff.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.

