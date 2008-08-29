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

has 'baseline' => (
    is  => 'rw',
    isa => 'Num',
);
# Remove for border...
has 'brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub { Graphics::Primitive::Brush->new }
);
has '+color' => (
    default => sub {
        Graphics::Color::RGB->new({
            red => 0, green => 0, blue => 0, alpha => 1
        })
    },
    coerce => 1
);
has 'font' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Font',
    default => sub { Graphics::Primitive::Font->new }
);
has 'format' => ( is => 'rw', isa => 'StrOrCodeRef' );
has 'fudge_amount' => ( is => 'rw', isa => 'Num', default => 0 );
has 'hidden' => ( is => 'rw', isa => 'Bool', default => 0 );
has 'label' => ( is => 'rw', isa => 'Str' );
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
has 'tick_brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub { Graphics::Primitive::Brush->new }
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

override('prepare', sub {
    my ($self, $driver) = @_;

    # return if $self->prepared;

    $self->clear_components;

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

    my $font = $self->font;

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
        my $tbox = $driver->get_text_bounding_box($font, $label);

        my $tlabel = Graphics::Primitive::TextBox->new(
            font => $font,
            text => $label,
            color => Graphics::Color::RGB->new(green => 0, blue => 0, red => 0),
        );
        $tlabel->prepare($driver);

        $tlabel->width($tlabel->minimum_width);
        $tlabel->height($tlabel->minimum_height);

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

        my $angle = 0;
        if($self->is_vertical) {
            # if ($self->is_left) {
            #     $angle -= pip2;
            # } else {
            #     $angle = pip2;
            # }
        }

        my $label = Graphics::Primitive::TextBox->new(
            name => 'label',
            font => $self->font,
            text => $self->label,
            angle => $angle,
            color => Graphics::Color::RGB->new( green => 0, blue => 0, red => 0),
        );
        $label->font->size($label->font->size);

        $label->prepare($driver);

        $label->width($label->minimum_width);
        $label->height($label->minimum_height);

        $label_width = $label->width;
        $label_height = $label->height;
        $self->add_component($label);
    }

    if($self->is_vertical) {
        $self->minimum_width($self->minimum_width + $big + $label_width);
        $self->minimum_height($self->minimum_height + $self->outside_height + $big);
    } else {
        $self->minimum_height($self->minimum_height + $big + $label_height);
        $self->minimum_width($self->minimum_width + $big + $self->outside_width);
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

override('pack', sub {
    my ($self) = @_;

    super;

    return if $self->hidden;

    my $x = 0;
    my $y = 0;

    my $width = $self->width;
    my $height = $self->height;
    my $ibb = $self->inside_bounding_box;

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
                $label->origin->x($ibb->origin->x + $ibb->width - $label->width);
                $label->origin->y($iy - ($label->height / 2));
            } else {
                $label->origin->x($ibb->origin->x);
                $label->origin->y($iy - ($label->height / 2));
            }
        }

        # Draw the label
        # FIXME Not working, rotated text labels...
        if($self->label) {
            my $label = $self->get_component($self->find_component('label'));

            if($self->is_left) {

                $label->origin->x($ibb->origin->x);
                $label->origin->y(($height - $label->height) / 2);
            } else {

                $label->origin->x($ibb->origin->x + $ibb->width - $label->width);
                $label->origin->y(($height - $label->height) / 2);
            }
        }
    } else {
        # Draw a tick for each value.
        for(0..scalar(@values) - 1) {
            my $val = $values[$_];
            my $ix = $self->mark($width, $val);

            my $label = $self->get_component($_);

            if($self->is_top) {
                $label->origin->x($ix - ($label->width / 1.8));
                $label->origin->y($ibb->origin->y + $ibb->height - $label->height);
            } else {
                $label->origin->x($ix - ($label->width / 1.8));
                $label->origin->y($ibb->origin->y);
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
    show_ticks => 1,
    brush = Graphics::Primitive::Brush->new,
    tick_length => 2,
    tick_brush => Graphics::Primitive::Brush->new,
    visible => 1,
  });

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Chart::Clicker::Axis.  If no arguments are given then sane
defaults are chosen.

=back

=head2 Instance Methods

=over 4

=item I<baseline>

Set the 'baseline' value of this axis.  This is used by some renderers to
change the way a value is marked.  The Bar render, for instance, considers
values below the base to be 'negative'.

=item I<brush>

Set/Get the brush for this axis.

=item I<color>

Set/Get the color of the axis.

=item I<font>

Set/Get the font used for the axis' labels.

=item I<format>

Set/Get the format to use for the axis values.

If the format is a string then format is applied to each value 'tick' via
sprintf.  See sprintf perldoc for details!  This is useful for situations
where the values end up with repeating decimals.

If the format is a coderef then that coderef will be executed and the value
passed to it as an argument.

  my $nf = Number::Format->new;
  $default->domain_axis->format(sub { return $nf->format_number(shift); });

=item I<fudge_amount>

Set/Get the amount to 'fudge' the span of this axis.  You should supply a
percentage (in decimal form) and the axis will grow at both ends by the
supplied amount.  This is useful when you want a bit of padding above and
below the dataset.

As an example, a fugdge_amount of .10 on an axis with a span of 10 to 50
would add 5 to the top and bottom of the axis.

=item I<height>

Set/Get the height of the axis.

=item I<label>

Set/Get the label of the axis.

=item I<orientation>

Set/Get the orientation of this axis.  See L<Chart::Clicker::Drawing>.

=item I<position>

Set/Get the position of the axis on the chart.

=item I<range>

Set/Get the Range for this axis.

=item I<show_ticks>

Set/Get the show ticks flag.  If this is value then the small tick marks at
each mark on the axis will not be drawn.

=item I<tick_length>

Set/Get the tick length.

=item I<tick_values>

Set/Get the arrayref of values show as ticks on this Axis.

=item I<add_to_tick_values>

Add a value to the list of tick values.

=item I<clear_tick_values>

Clear all tick values.

=item I<tick_brush>

Set/Get the stroke for the tick markers.

=item I<tick_value_count>

Get a count of tick values.

=item I<tick_labels>

Set/Get the arrayref of labels to show for ticks on this Axis.  This arrayref
is consulted for every tick, in order.  So placing a string at the zeroeth
index will result in it being displayed on the zeroeth tick, etc, etc.

=item I<ticks>

Set/Get the number of 'ticks' to show.  Setting this will divide the
range on this axis by the specified value to establish tick values.  This
will have no effect if you specify tick_values.

=item I<mark>

Given a span and a value, returns it's pixel position on this Axis.

=item I<format_value>

Given a value, returns it formatted using this Axis' formatter.

=item I<prepare>

Prepare this Axis by determining the size required.  If the orientation is
CC_HORIZONTAL this method sets the height.  Otherwise sets the width.

=item I<draw>

Draw this axis.

=item I<hidden>

Set/Get this axis' hidden flag.

=item I<width>

Set/Get this axis' width.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.

