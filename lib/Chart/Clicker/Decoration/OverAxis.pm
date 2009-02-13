package Chart::Clicker::Decoration::OverAxis;
use Moose;

extends 'Chart::Clicker::Container';

use Graphics::Color::RGB;
use Graphics::Primitive::Operation::Fill;
use Graphics::Primitive::Paint::Solid;
use Layout::Manager::Flow;

has 'axis_height' => (
    is => 'rw',
    isa => 'Num',
    default => sub { 20 }
);
has 'background_color' => (
    is => 'rw',
    isa => 'Graphics::Color::RGB',
    default => sub {
        Graphics::Color::RGB->new(
            red => .18, green => .17, blue => .17, alpha => 1
        )
    }
);
has 'context' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);
has '+layout_manager' => (
    default => sub { Layout::Manager::Compass->new }
);
has 'line_color' => (
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

    $self->height(20);

    my $ctx = $self->clicker->get_context($self->context);
    my $domain = $ctx->domain_axis;

    my $ticks = $domain->tick_values;
    my $tick_count = scalar(@{ $ticks });
    my $per = $self->width / $tick_count;

    foreach my $tick (@{ $ticks }) {

        my $tb = Graphics::Primitive::TextBox->new(
            text => $tick,
            color => Graphics::Color::RGB->new,
            horizontal_alignment => 'center',
            vertical_alignment => 'center',
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
    $self->border->top->width(2);
    $self->border->bottom->width(2);
    $self->border->color(Graphics::Color::RGB->new);
    $self->height($self->axis_height);

    my $ticks = $domain->tick_values;
    for(my $i = 0; $i < scalar(@{ $ticks }); $i++) {
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
__END__

=head1 NAME

Chart::Clicker::Decoration::OverAxis

=head1 DESCRIPTION

An axis that is meant to be drawn "over" a chart, 

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Chart::Clicker::Decoration::OverAxis object.

=back

=head2 Instance Methods

=over 4

=item I<background_color>

Set/Get the background color for this OverAxis.

=item I<draw>

Draw this Grid.

=item I<glare_color>

Set/Get the glare color for this OverAxis.

=item I<prepare>

Prepare this OverAxis for drawing

=cut

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
