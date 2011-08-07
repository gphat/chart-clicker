package Chart::Clicker::Renderer;
use Moose;

extends 'Graphics::Primitive::Canvas';

# ABSTRACT: Base class for renderers

=head1 DESCRIPTION

Chart::Clicker::Renderer represents the plot of the chart.

=head1 SYNOPSIS

  my $renderer = Chart::Clicker::Renderer::Foo->new();
  
=attr additive

Read-only value that informs Clicker that this renderer uses the combined ranges
of all the series it charts in total.  Used for 'stacked' renderers like
StackedBar, StackedArea and Line (which will stack if told to).  Note: If you
set a renderer to additive that B<isn't> additive, this will produce wonky
results.

=cut

has 'additive' => ( is => 'rw', isa => 'Bool', default => 0 );

has 'clicker' => ( is => 'rw', isa => 'Chart::Clicker' );

=attr context

The context to which this Renderer is attached.

=cut

has 'context' => ( is => 'rw', isa => 'Str' );

override('prepare', sub {
    my ($self) = @_;

    return 1;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;