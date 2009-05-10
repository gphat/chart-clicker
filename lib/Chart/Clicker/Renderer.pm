package Chart::Clicker::Renderer;
use Moose;

extends 'Graphics::Primitive::Canvas';

has 'additive' => ( is => 'rw', isa => 'Bool', default => 0 );
has 'clicker' => ( is => 'rw', isa => 'Chart::Clicker' );
has 'context' => ( is => 'rw', isa => 'Str' );

override('prepare', sub {
    my ($self) = @_;

    return 1;
});

__PACKAGE__->meta->make_immutable;

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

=head2 new

Creates a new Chart::Clicker::Renderer.

=head2 additive

Read-only value that informs Clicker that this renderer uses the combined ranges
of all the series it charts in total.  Used for 'stacked' renderers like
StackedBar, StackedArea and Line (which will stack if told to).  Note: If you
set a renderer to additive that B<isn't> additive, this will produce wonky
results.

=head2 prepare

Prepare the component.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
