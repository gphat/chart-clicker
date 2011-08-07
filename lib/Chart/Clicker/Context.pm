package Chart::Clicker::Context;
use Moose;

# ABSTRACT: A rendering context: Axes, Markers and a Renderer

use Chart::Clicker::Axis;
use Chart::Clicker::Renderer::Line;

=head1 DESCRIPTION

Contexts represent the way a dataset should be charted.  Multiple contexts
allow a chart with multiple renderers and axes.  See the CONTEXTS section
in L<Chart::Clicker>.

=head1 SYNOPSIS

  my $context = Chart::Clicker::Context->new(
    name => 'Foo'
  );
  $clicker->add_to_contexts('foo', $context);

=attr domain_axis

Set/get this context's domain axis

=cut

has 'domain_axis' => (
    is => 'rw',
    isa => 'Chart::Clicker::Axis',
    default => sub {
        Chart::Clicker::Axis->new(
            orientation => 'horizontal',
            position    => 'bottom',
            format      => '%0.2f'
        )
    }
);

=attr markers

An arrayref of L<Chart::Clicker::Data::Marker>s for this context.

=method add_marker

Add a marker to this context.

=method marker_count

Get a count of markers in this context.

=cut

has 'markers' => (
    traits => [ 'Array' ],
    is => 'rw',
    isa => 'ArrayRef[Chart::Clicker::Data::Marker]',
    default => sub { [] },
    handles => {
        'marker_count' => 'count',
        'add_marker' => 'push'
    }
);

=attr name

Set/get this context's name

=cut

has 'name' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

=attr range_axis

Set/get this context's range axis

=cut

has 'range_axis' => (
    is => 'rw',
    isa => 'Chart::Clicker::Axis',
    default => sub {
        Chart::Clicker::Axis->new(
            orientation => 'vertical',
            position    => 'left',
            format      => '%0.2f'
        )
    }
);

=head2 renderer

Set/get this context's renderer

=cut

has 'renderer' => (
    is => 'rw',
    isa => 'Chart::Clicker::Renderer',
    default => sub { Chart::Clicker::Renderer::Line->new },
);

=method share_axes_with ($other_context)

Sets this context's axes to those of the supplied context.  This is a
convenience method for quickly sharing axes.  It's simple doing:

  $self->range_axis($other_context->range_axis);
  $self->domain_axis($other_context->domain_axis);

=cut

sub share_axes_with {
    my ($self, $other_context) = @_;

    $self->range_axis($other_context->range_axis);
    $self->domain_axis($other_context->domain_axis);
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;