package Chart::Clicker::Context;
use Moose;

use Chart::Clicker::Axis;
use Chart::Clicker::Renderer::Line;

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
has 'name' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);
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
has 'renderer' => (
    is => 'rw',
    isa => 'Chart::Clicker::Renderer',
    default => sub { Chart::Clicker::Renderer::Line->new },
);

sub share_axes_with {
    my ($self, $other_context) = @_;

    $self->range_axis($other_context->range_axis);
    $self->domain_axis($other_context->domain_axis);
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Context - A rendering context: Axes, Markers and a Renderer

=head1 DESCRIPTION

Contexts represent the way a dataset should be charted.  Multiple contexts
allow a chart with multiple renderers and axes.  See the CONTEXTS section
in L<Chart::Clicker>.

=head1 SYNOPSIS

  my $context = Chart::Clicker::Context->new(
    name => 'Foo'
  );
  $clicker->add_to_contexts('foo', $context);

=head1 ATTRIBUTES

=head2 domain_axis

Set/get this context's domain axis

=head2 name

Set/get this context's name

=head2 range_axis

Set/get this context's range axis

=head2 renderer

Set/get this context's renderer

=head1 METHODS

=head2 new

Creates a new Context object.

=head2 share_axes_with ($other_context)

Sets this context's axes to those of the supplied context.  This is a
convenience method for quickly sharing axes.  It's simple doing:

  $self->range_axis($other_context->range_axis);
  $self->domain_axis($other_context->domain_axis);

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
