package Chart::Clicker::Decoration::Plot;
use Moose;
use MooseX::AttributeHelpers;

use Layout::Manager::Axis;
use Layout::Manager::Single;
# TODO READD THIS
#use Chart::Clicker::Decoration::MarkerOverlay;

# TODO MOve this class?  It's not decoration anymore.
extends 'Chart::Clicker::Container';

has '+background_color' => ( default => sub { Graphics::Color::RGB->new( red => 1 ) });
has '+border' => ( default => sub { Graphics::Primitive::Border->new( width => 0 )});
has 'clicker' => (
    is => 'rw',
    isa => 'Chart::Clicker',
);
has '+layout_manager' => (
    default => sub { Layout::Manager::Axis->new }
);
has 'markers' => (
    is => 'rw',
    isa => 'Bool',
    default => 1
);
has 'render_area' => (
    is => 'rw',
    isa => 'Chart::Clicker::Container',
    default => sub {
        Chart::Clicker::Container->new(
            name => 'render_area',
            layout_manager => Layout::Manager::Single->new
        )
    }
);

override('prepare', sub {
    my ($self) = @_;

    $self->add_component($self->render_area, 'c');

    # TODO This is also happening in Clicker.pm
    foreach my $c (@{ $self->components }) {
        $c->{component}->clicker($self->clicker);
    }

    # TODO This is kinda messy...
    foreach my $c (@{ $self->render_area->components }) {
        $c->{component}->clicker($self->clicker);
    }

    super;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::Plot

=head1 DESCRIPTION

A Component that handles the rendering of data via Renderers.  Also
handles rendering the markers that come from the Clicker object.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Plot object.

=back

=head2 Instance Methods

=over 4

=item I<background_color>

Set/Get this Plot's background color.

=item I<border>

Set/Get this Plot's border.

=item I<clicker>

Set/Get this Plot's clicker instance.

=item I<draw>

Draw this Plot

=item I<layout>

Set/Get this Plot's layout.  See L<Layout::Manager>.

=item I<markers>

Set/Get the flag that determines if markers are drawn on this plot.

=item I<prepare>

Prepare this Plot by determining how much space it needs.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
