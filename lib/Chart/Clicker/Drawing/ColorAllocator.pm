package Chart::Clicker::Drawing::ColorAllocator;
use Moose;

use MooseX::AttributeHelpers;

use Graphics::Color;

my @defaults = (qw());;

has 'colors' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        'push' => 'add_to_colors',
        'clear' => 'clear_colors',
        'count' => 'color_count',
        'get'   => 'get_color'
    }
);
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

        $self->add_to_colors(
            Graphics::Color::RGB->new(
                red     => rand(1),
                green   => rand(1),
                blue    => rand(1),
                alpha   => 1
            )
        );
    }
};

sub reset {
    my $self = shift();

    $self->position(-1);
    return 1;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Drawing::ColorAllocator

=head1 DESCRIPTION

Allocates colors for use in the chart.  The position in the color allocator
corresponds to the series that will be colored.

=head1 SYNOPSIS

    use Graphics::Color::RGB;
    use Chart::Clicker::Drawing::ColorAllocator;

    my $ca = Chart::Clicker::Drawing::ColorAllocator->new({
        colors => (
            Graphics::Color::RGB->new(
                red => 1.0, green => 0, blue => 0, alpha => 1.0
            ),
            ...
        )
    });

    my $red = $ca->get(0);

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Create a new ColorAllocator.  You can optionally pass an arrayref of colors
to 'seed' the allocator.

=back

=head2 Methods

=over 4

=item I<add_to_colors>

Add a color to this allocator.

=item I<clear_colors>

Clear this allocator's colors

=item I<color_count>

Get the number of colors in this allocator.

=item <get_color>

Gets the color at the specified index.  Returns undef if that position has no
color.

=item I<position>

Gets the current position.

=item I<next>

Returns the next color.  Each call to next increments the position, so
subsequent calls will return different colors.

=item I<reset>

Resets this allocator back to the beginning.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
