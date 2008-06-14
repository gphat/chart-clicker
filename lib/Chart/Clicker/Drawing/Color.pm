package Chart::Clicker::Drawing::Color;
use Moose;
use Moose::Util::TypeConstraints;

has 'red' => ( is => 'rw', isa => 'Num' );
has 'green' => ( is => 'rw', isa => 'Num' );
has 'blue' => ( is => 'rw', isa => 'Num' );
has 'alpha' => ( is => 'rw', isa => 'Num' );
has 'name' => ( is => 'rw', isa => 'Str' );

subtype 'Color'
    => as 'Object'
    => where { $_->isa('Chart::Clicker::Drawing::Color') };

coerce 'Color'
    => from 'Str'
        => via { new Chart::Clicker::Drawing::Color(name => $_) };

my %colors = (
    'aqua'      => [   0,   1,   1,  1 ],
    'black'     => [   0,   0,   0,  1 ],
    'blue'      => [   0,   0,   1,  1 ],
    'fuchsia'   => [   1,   0,   0,  1 ],
    'gray'      => [ .31, .31, .31,  1 ],
    'green'     => [   0, .31,   0,  1 ],
    'lime'      => [   0,   1,   0,  1 ],
    'maroon'    => [ .31,   0,   0,  1 ],
    'navy'      => [   0,   0, .31,  1 ],
    'olive'     => [ .31, .31,   0,  1 ],
    'purple'    => [ .31,   0, .31,  1 ],
    'red'       => [   1,   0,   0,  1 ],
    'silver'    => [ .75, .75, .75,  1 ],
    'teal'      => [   0, .31, .31,  1 ],
    'white'     => [   1,   1,   1,  1 ],
    'yellow'    => [   1,   1,   0,  1 ],
);

# TODO How to moose this up?
sub new {
    my $proto = shift();
    my $self = $proto->SUPER::new(@_);

    unless(defined($self->red())) {
        if($self->name()) {
            my $name = lc($self->name());
            if(exists($colors{$name})) {
                $self->red($colors{$name}->[0]);
                $self->green($colors{$name}->[1]);
                $self->blue($colors{$name}->[2]);
                $self->alpha($colors{$name}->[3]);
            }
        }
    }

    return $self;
}

sub as_string {
    my $self = shift();

    return sprintf('%0.2f,%0.2f,%0.2f,%0.2f',
        $self->red(), $self->green(),
        $self->blue(), $self->alpha()
    );
}

sub clone {
    my $self = shift();

    return new Chart::Clicker::Drawing::Color({
        red => $self->red(), green => $self->green(),
        blue => $self->blue(), alpha => $self->alpha()
    });
}

sub rgb {
    my $self = shift();

    return ($self->red(), $self->green(), $self->blue());
}

sub rgba {
    my $self = shift();

    return ($self->red(), $self->green(), $self->blue(), $self->alpha());
}

sub names {
    my $self = shift();

    return keys(%colors);
}

1;
__END__

=head1 NAME

Chart::Clicker::Drawing::Color

=head1 DESCRIPTION

Chart::Clicker::Drawing::Color represents a Color in the sRGB color space.  Used to
make charts pertier.

The 16 colors defined by the W3C CSS specification are supported via
the 'name' parameter of the constructor.  The colors are aqua, black, blue,
fuchsia, gray, green, lime, maroon, navy, olive, purple, red, silver, teal,
white and yellow.  Any case is fine, navy, NAVY or Navy.

=head1 SYNOPSIS

    use Chart::Clicker::Drawing::Color;

    my $color = new Chart::Clicker::Drawing::Color({
        red     => 1,
        blue    => .31,
        green   => .25,
        alpha   => 1
    });

    my $aqua = new Chart::Clicker::Drawing::Color({ name => 'aqua' });

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Chart::Clicker::Drawing::Color.

=back

=head2 Class Methods

=over 4

=item red

Set/Get the red component of this Color.

=item green

Set/Get the green component of this Color.

=item blue

Set/Get the blue component of this Color.

=item alpha

Set/Get the alpha component of this Color.

=item name

Get the name of this color.  Only valid if the color was created by name.

=item as_string

Get a string version of this Color in the form of RED, GREEN, BLUE, ALPHA

=item clone

Clone this color

=item rgb

Get the RGB values as an array

=item rgba

Get the RGBA values as an array

=back

=head2 Static Methods

=over 4

=item names

Gets the list of predefined color names.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
