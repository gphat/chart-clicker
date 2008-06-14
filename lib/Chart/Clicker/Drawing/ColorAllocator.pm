package Chart::Clicker::Drawing::ColorAllocator;
use Moose;

use Chart::Clicker::Drawing::Color;

my @defaults = (qw(red green blue lime yellow maroon teal fuchsia));;

has 'colors' => ( is => 'rw', isa => 'ArrayRef', default => sub { [] } );
has 'position' => ( is => 'rw', isa => 'Int', default => -1 );

sub next {
    my $self = shift();

    $self->position($self->position() + 1);

    return $self->colors->[$self->position()];
}

# Before we attempt to get the next color, we'll instantiate it if we need it
# that way we don't waste a bunch of memory with useless colors.
before 'next' => sub {
    my $self = shift();

    my $pos = $self->position();
    if(!defined($self->colors->[$pos + 1])) {

        if($self->position() <= scalar(@defaults)) {
            $self->colors->[$pos + 1] =
                new Chart::Clicker::Drawing::Color({
                    name => $defaults[$pos + 1]
                });
        } else {
            $self->colors->[$pos + 1] = new Chart::Clicker::Drawing::Color(
                red     => rand(1),
                green   => rand(1),
                blue    => rand(1),
                alpha   => 1
            );
        }
    }
};

sub reset {
    my $self = shift();

    $self->position(-1);
    return 1;
}

sub get {
    my $self = shift();
    my $index = shift();

    return $self->colors->[$index];
}

1;
__END__

=head1 NAME

Chart::Clicker::Drawing::ColorAllocator

=head1 DESCRIPTION

Allocates colors for use in the chart.  The position in the color allocator
corresponds to the series that will be colored.

=head1 SYNOPSIS

    use Chart::Clicker::Drawing::ColorAllocator;

    my $ca = new Chart::Clicker::Drawing::ColorAllocator({
        colors => (
            new Chart::Clicker::Drawing::Color(1.0, 0, 0, 1.0),
            ...
        )
    });

    my $red = $ca->get(0);

=head1 METHODS

=head2 Constructor

=over 4

=item new

Create a new ColorAllocator.  You can optionally pass an arrayref of colors
to 'seed' the allocator.

=back

=head2 Class Methods

=over 4

=item position

Gets the current position.

=item next

Returns the next color.  Each call to next increments the position, so
subsequent calls will return different colors.

=item reset

Resets this allocator back to the beginning.

=item get

Gets the color at the specified index.  Returns undef if that position has no
color.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
