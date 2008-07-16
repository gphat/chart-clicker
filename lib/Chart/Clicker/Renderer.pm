package Chart::Clicker::Renderer;
use Moose;

extends 'Chart::Clicker::Drawing::Component';

has 'additive' => ( is => 'ro', isa => 'Bool', default => 0 );
has '+border' => ( default => sub { Graphics::Primitive::Border->new( width => 0 )});
has 'context' => ( is => 'rw', isa => 'Str' );

override('prepare', sub {
    my $self = shift();

    return 1;
});

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Renderer

=head1 DESCRIPTION

Chart::Clicker::Renderer represents the plot of the chart.

=head1 SYNOPSIS

  my $renderer = Chart::Clicker::Renderer::Foo->new();

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Chart::Clicker::Renderer.

=back

=head2 Instance Methods

=over 4

=item I<additive>

Read-only value that informs Clicker that this renderer uses the combined ranges
of all the series it charts in total.  Used for 'stacked' renderers like
StackedBar.

=item I<prepare>

Prepare the component.

=item I<draw>

Draw the renderer.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
