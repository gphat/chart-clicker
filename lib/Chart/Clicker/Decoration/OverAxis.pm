package Chart::Clicker::Decoration::OverAxis;
use Moose;

extends 'Chart::Clicker::Container';

# ABSTRACT: An axis drawn over data

use Graphics::Color::RGB;
use Graphics::Primitive::Operation::Fill;
use Graphics::Primitive::Paint::Solid;
use Layout::Manager::Flow;

=head1 DESCRIPTION

An axis that is meant to be drawn "over" a chart.  You can find an example
of an OverAxis at L<http://gphat.github.com/chart-clicker/static/images/examples/overaxis.png>.

=attr axis_height

Set/Get the height of the OverAxis that will be drawn.

=cut

has 'axis_height' => (
    is => 'rw',
    isa => 'Num',
    default => sub { 20 }
);

=attr background_color

Set/Get the background color for this OverAxis.

=cut

has '+background_color' => (
    # is => 'rw',
    # isa => 'Graphics::Color::RGB',
    default => sub {
        Graphics::Color::RGB->new(
            red => .18, green => .17, blue => .17, alpha => 1
        )
    }
);

=attr border_color

Set/Get the border color for this OverAxis.

=cut

has 'border_color' => (
    is => 'rw',
    isa => 'Graphics::Color::RGB',
    default => sub {
        Graphics::Color::RGB->new(
            red => 1, green => 1, blue => 1, alpha => 1
        )
    }
);

=attr border_width

Set/Get the width of the border for this OverAxis

=cut

has 'border_width' => (
    is => 'rw',
    isa => 'Num',
    default => sub { 2 }
);

=attr context

Set/Get the context that this OverAxis should use.

=cut

has 'context' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

=attr font

The font to use for the OverAxis.

=cut

has 'font' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Font',
    default => sub { Graphics::Primitive::Font->new }
);

=attr layout_manager

The layout manager to use for this overaxis.  Defaults to a
L<Layout::Manager::Compass>.

=cut

has '+layout_manager' => (
    default => sub { Layout::Manager::Compass->new }
);

=attr text_color

Set/Get the color of the text labels dawn for the ticks.

=cut

has 'text_color' => (
    is => 'rw',
    isa => 'Graphics::Color::RGB',
    default => sub {
        Graphics::Color::RGB->new(
            red => 1, green => 1, blue => 1, alpha => 1
        )
    }
);

override('prepare', sub {
    my ($self) = @_;

    $self->height($self->axis_height);

    my $ctx = $self->clicker->get_context($self->context);
    my $domain = $ctx->domain_axis;

    my $ticks = $domain->tick_values;
    my $tick_count = scalar(@{ $ticks });
    my $per = $self->width / $tick_count;

    foreach my $tick (@{ $ticks }) {

        my $tb = Graphics::Primitive::TextBox->new(
            text => $tick,
            color => $self->text_color,
            horizontal_alignment => 'center',
            vertical_alignment => 'center',
            font => $self->font
        );

        $self->add_component($tb, 'w');
    }
    super;
});

override('finalize', sub {
    my ($self) = @_;

    my $ctx = $self->clicker->get_context($self->context);
    my $domain = $ctx->domain_axis;
    my $range = $ctx->range_axis;

    my $y = $range->mark($self->height, $range->baseline);

    my $axis_y = $y - ($self->axis_height / 2);

    $self->origin->x(0);
    $self->origin->y($axis_y);
    $self->border->top->width($self->border_width);
    $self->border->bottom->width($self->border_width);
    $self->border->color($self->border_color);
    $self->height($self->axis_height);

    my $ticks = $domain->tick_values;
    for my $i (0 .. $#{ $ticks }) {
        my $tick = $ticks->[$i];

        my $comp = $self->get_component($i);
        $comp->width($self->width / scalar(@{ $ticks }));
        $comp->origin->x(
            $domain->mark($self->width, $tick) - $comp->width / 2
        );
        $comp->height($self->axis_height);
    }
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;