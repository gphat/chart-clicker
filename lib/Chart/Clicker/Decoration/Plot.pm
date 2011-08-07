package Chart::Clicker::Decoration::Plot;
use Moose;

# ABSTRACT: Area on which renderers draw

use Layout::Manager::Axis;
use Layout::Manager::Single;

use Chart::Clicker::Decoration::Grid;

extends 'Chart::Clicker::Container';

=head1 DESCRIPTION

A Component that handles the rendering of data via Renderers.  Also
handles rendering the markers that come from the Clicker object.

=attr background_color

Set/Get this Plot's background color.

=attr border

Set/Get this Plot's border.

=cut

has 'clicker' => (
    is => 'rw',
    isa => 'Chart::Clicker',
);

=attr grid

Set/Get the Grid component used on this plot.

=cut

has 'grid' => (
    is => 'rw',
    isa => 'Chart::Clicker::Decoration::Grid',
    default => sub {
        Chart::Clicker::Decoration::Grid->new( name => 'grid' )
    }
);

=attr layout_manager

Set/Get the layout manager for this plot.  Defaults to
L<Layout::Manager::Axis>.

=cut

has '+layout_manager' => (
    default => sub { Layout::Manager::Axis->new }
);

=attr render_area

Set/Get the container used to render within.

=cut

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

    # TODO This is also happening in Clicker.pm
    foreach my $c (@{ $self->components }) {
        $c->clicker($self->clicker);
    }

    # TODO This is kinda messy...
    foreach my $c (@{ $self->render_area->components }) {
        $c->clicker($self->clicker);
    }

    super;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;