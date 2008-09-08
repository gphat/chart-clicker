package Chart::Clicker::Decoration::Plot;
use Moose;
use MooseX::AttributeHelpers;

use Layout::Manager::Axis;
use Layout::Manager::Single;

use Chart::Clicker::Decoration::Grid;

# TODO READD THIS
#use Chart::Clicker::Decoration::MarkerOverlay;

# TODO MOve this class?  It's not decoration anymore.
extends 'Chart::Clicker::Container';

has '+background_color' => ( default => sub { Graphics::Color::RGB->new( red => 1 ) });
has 'clicker' => (
    is => 'rw',
    isa => 'Chart::Clicker',
);
has 'grid' => (
    is => 'rw',
    isa => 'Chart::Clicker::Decoration::Grid',
    default => sub {
        Chart::Clicker::Decoration::Grid->new( name => 'grid' )
    }
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

    # return if $self->prepared;
    # $self->clear_components;

    $self->add_component($self->render_area, 'c');

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

# override('finalize', sub {
#     my ($self) = @_;
# 
#     if($self->grid->visible) {
#         $self->grid->clicker($self->clicker);
#         $self->grid->width($self->width);
#         $self->grid->height($self->height);
#         $self->render_area->add_component($self->grid, 'c');
#     }
# 
#     if($self->markers) {
#         $self->render_area->add_component(
#             Chart::Clicker::Decoration::MarkerOverlay->new(
#                 width => $self->width,
#                 height => $self->height,
#                 clicker => $self->clicker
#             )
#         );
#     }
#     $self->render_area->clicker;
#     $self->render_area->width($self->width);
#     $self->render_area->height($self->height);
#     $self->add_component($self->render_area, 'c');
# });

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

=item I<grid>

Set/Get the Grid component used on this plot.

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
