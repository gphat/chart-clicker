package Chart::Clicker::Drawing::ColorAllocator;
use Moose;

# ABSTRACT: Color picker

use Graphics::Color::RGB;
use Color::Scheme;

=head1 DESCRIPTION

Allocates colors for use in the chart.  The position in the color allocator
corresponds to the series that will be colored.

=head1 SYNOPSIS

    use Graphics::Color::RGB;
    use Chart::Clicker::Drawing::ColorAllocator;

    my $ca = Chart::Clicker::Drawing::ColorAllocator->new({
        colors => [
            Graphics::Color::RGB->new(
                red => 1.0, green => 0, blue => 0, alpha => 1.0
            ),
            #...
        ]
    });

    my $red = $ca->get(0);

    #or let Chart::Clicker autmatically pick complementing colors for you
    my $ca2 = Chart::Clicker::Drawing::ColorAllocator->new({
        seed_hue => 0, #red
    });

=begin :prelude

=head1 AUTOMATIC COLOR ALLOCATION

This module has the capacity to automatically allocate 96 individual colors
using L<Color::Scheme>. It does so by picking 4 hues equally spaced in the
color wheel from the C<seed_hue> (0 (red) would be complimented by 270 (blue),
180 (green) and 90 (yellow)). After those colors are allocated it moves on to
picking from the colors between those ( 45, 135, 215, 305 ) etc. Once all
values of C<hues> have been utilized, it repeats them using a different shade.
This has the effect of generating evenly spaced complementing colors to ensure
colors are well ditinguishable from one another and have appropriate contrast.

=end :prelude

=cut

=attr colors

An arrayref of colors that will be used for series that Clicker draws.

=method add_to_colors

Add a color to this allocator.

=method clear_colors

Clear this allocator's colors

=method color_count

Get the number of colors in this allocator.

=method get_color ($index)

Gets the color at the specified index.  Returns undef if that position has no
color.

=cut

has 'colors' => (
    traits => [ 'Array' ],
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    handles => {
        'add_to_colors' => 'push',
        'clear_colors' => 'clear',
        'color_count' => 'count',
        'get_color' => 'get'
    }
);

=head2 position

Gets the current position.

=cut

has 'position' => ( is => 'rw', isa => 'Int', default => -1 );

=attr color_scheme

A lazy-building L<Color::Scheme> object used to generate the color scheme of
the chart;

=cut

has 'color_scheme' => (
    is => 'rw',
    isa => 'Color::Scheme',
    lazy_build => 1,
);

=attr seed_hue

The interger value of the first hue used when computing the tetrade color
scheme. Setting this will affect the hue of the first color allocated.
Subsequent colors will be allocated based on their distance from this color
to maintain sifficient contrast between colors. If not specified the seed_hue
will default to 270, blue.

=cut

has 'seed_hue' => (
    is => 'rw',
    isa => 'Int',
    required => 1,
    default => 270,
);

=attr hues

An array reference of evenly spaced seed hues for color allocation. By default
it will use the seed hue plus 0, 45, 75, 15, 60 and 30 which is enough to cover
all web-safe colors when using a tetrade color scheme.

=cut

has hues => (
    is => 'rw',
    isa => 'ArrayRef',
    required => 1,
    lazy => 1,
    default => sub {
      my $seed = shift->seed_hue;
      [ map { ($seed + $_) % 360 } (0, 45, 75, 15, 60, 30) ]
    },
);

=attr shade_order

An array reference of the order in which the different shades of each color
will be used for every color scheme generated. It defaults to 1, 3, 0, 2 for
optimum color spacing.

=cut

has shade_order => (
    is => 'rw',
    isa => 'ArrayRef',
    required => 1,
    default => sub { [1, 3, 0, 2] },
);

sub _build_color_scheme {
  my $self = shift;
  my $scheme = Color::Scheme->new;
  $scheme->scheme('tetrade');
  $scheme->web_safe(1);
  $scheme->distance(1);
  return $scheme;
}

=method next

Returns the next color.  Each call to next increments the position, so
subsequent calls will return different colors.

=cut

sub next {
    my $self = shift;

    $self->position($self->position + 1);

    return $self->colors->[$self->position];
}

# Before we attempt to get the next color, we'll instantiate it if we need it
# that way we don't waste a bunch of memory with useless colors.
before 'next' => sub {
    my $self = shift;

    my $pos = $self->position;
    if(!defined($self->colors->[$pos + 1])) {
        $self->add_to_colors($self->allocate_color);
    }
};

=method allocate_color

Determines what the next color should be.

=cut

sub allocate_color {
  my $self = shift;

  my $pos = $self->position + 1;
  my $scheme = $self->color_scheme;

  my $hue_cnt = @{ $self->hues };
  my $hue_pos = int($pos / 4) % $hue_cnt;
  $scheme->from_hue($self->hues->[$hue_pos]);

  my $shade_pos = int($pos / ( $hue_cnt * 4)) % 4;
  my $shade_idx = $self->shade_order->[$shade_pos];
  my $color_idx = $pos % 4;

  my $color_hex = $scheme->colorset->[$color_idx]->[$shade_idx];
  my ($r,$g,$b) = ( map{ hex } ($color_hex =~ /(..)(..)(..)/));
  my $color = Graphics::Color::RGB->new(
    red     => $r / 255,
    green   => $g / 255,
    blue    => $b / 255,
    alpha   => 1,
  )
}

=method reset

Resets this allocator back to the beginning.

=cut

sub reset {
    my $self = shift;

    $self->position(-1);
    return 1;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
