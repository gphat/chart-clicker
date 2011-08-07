package Chart::Clicker::Decoration::Grid;
use Moose;

extends 'Graphics::Primitive::Canvas';

with 'Graphics::Primitive::Oriented';

# ABSTRACT: Under-data grid

use Graphics::Color::RGB;

=head1 DESCRIPTION

Generates a collection of Markers for use as a background.

=attr background_color

Set/Get the background_color for this Grid.

=cut

has '+background_color' => (
    default => sub {
        Graphics::Color::RGB->new(
            red => 0.9, green => 0.9, blue => 0.9, alpha => 1
        )
    }
);

=attr border

Set/Get the border for this Grid.

=attr color

Set/Get the color for this Grid.

=cut

has 'clicker' => ( is => 'rw', isa => 'Chart::Clicker' );

=attr domain_brush

Set/Get the brush for inking the domain markers.

=cut

has 'domain_brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub {
        Graphics::Primitive::Brush->new(
            color => Graphics::Color::RGB->new(
                red => .75, green => .75, blue => .75, alpha => 1
            ),
            width => 1
        )
    }
);

=attr range_brush

Set/Get the brush for inking the range markers.

=cut

has 'range_brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub {
        Graphics::Primitive::Brush->new(
            color => Graphics::Color::RGB->new(
                red => .75, green => .75, blue => .75, alpha => 1
            ),
            width => 1
        )
    }
);

=attr show_domain

Flag to show or not show the domain lines.

=cut

has 'show_domain' => (
    is => 'rw',
    isa => 'Bool',
    default => 1
);

=attr show_range

Flag to show or not show the range lines.

=cut

has 'show_range' => (
    is => 'rw',
    isa => 'Bool',
    default => 1
);

=attr stroke

Set/Get the Stroke for this Grid.

=cut

override('finalize', sub {
    my $self = shift();

    return unless ($self->show_domain || $self->show_range);

    my $clicker = $self->clicker;

    my $dflt = $clicker->get_context('default');
    my $daxis = $dflt->domain_axis;
    my $raxis = $dflt->range_axis;

    if($self->show_domain) {
        $self->draw_lines($daxis);
        my $dop = Graphics::Primitive::Operation::Stroke->new;
        $dop->brush($self->domain_brush);
        $self->do($dop);
    }

    if($self->show_range) {
        $self->draw_lines($raxis);
        my $rop = Graphics::Primitive::Operation::Stroke->new;
        $rop->brush($self->range_brush);
        $self->do($rop);
    }
});

=method draw_lines

Called by pack, draws the lines for a given axis.

=cut

sub draw_lines {
    my ($self, $axis) = @_;

    my $height = $self->height;
    my $width = $self->width;

    if($axis->is_horizontal) {

        foreach my $val (@{ $axis->tick_values }) {
            my $mark = $axis->mark($width, $val);
            # Don't try and draw a mark if the Axis wouldn't give us a value,
            # it might be skipping...
            next unless defined($mark);
            $self->move_to($mark, 0);
            $self->rel_line_to(0, $height);
        }
    } else {

        foreach my $val (@{ $axis->tick_values }) {
            my $mark = $axis->mark($height, $val);
            # Don't try and draw a mark if the Axis wouldn't give us a value,
            # it might be skipping...
            next unless defined($mark);
            $self->move_to(0, $height - $mark);
            $self->rel_line_to($width, 0);
        }
    }
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
