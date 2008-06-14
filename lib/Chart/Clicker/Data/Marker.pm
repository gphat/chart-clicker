package Chart::Clicker::Data::Marker;
use Moose;

use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::Stroke;

has 'key' => ( is => 'rw', isa => 'Num' );
has 'key2' => ( is => 'rw', isa => 'Num' );
has 'value' => ( is => 'rw', isa => 'Num' );
has 'value2' => ( is => 'rw', isa => 'Num' );
has 'inside_color' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Color',
    default => sub {
        new Chart::Clicker::Drawing::Color(
            red => 0, green => 0, blue => 0, alpha => 1
        );
    }
);
has 'color' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Color',
    default => sub {
        new Chart::Clicker::Drawing::Color(
            red => 0, green => 0, blue => 0, alpha => 1
        );
    }
);
has 'stroke' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Stroke',
    default => sub {
        new Chart::Clicker::Drawing::Stroke();
    }
);

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::Marker

=head1 DESCRIPTION

Used to highlight a particular key, value or range of either.

=head1 SYNOPSIS

 use Chart::Clicker::Decoration::Marker;
 use Chart::Clicker::Drawing::Color;
 use Chart::Clicker::Drawing::Stroke;

 my $mark = new Chart::Clicker::Decoration::Marker({
    color=  > new Chart::Clicker::Drawing::Color({ name => 'red' }),
    stroke  => new CHart::Clicker::Drawing::Stroke(),
    key     => 12,
    value   => 123,
    # Optionally
    key2    => 13,
    value   => 146
 });

=head1 METHODS

=head2 Constructor

=over 4

=item new

=back

=head2 Class Methods

=over 4

=item color

Set/Get the color for this marker.

=item stroke

Set/Get the stroke for this Marker.

=item key

Set/Get the key for this marker.  This represents a point on the domain.

=item key2

Set/Get the key2 for this marker.  This represents a second point on the domain
and is used to specify a range.

=item value

Set/Get the value for this marker.  This represents a point on the range.

=item value2

Set/Get the value2 for this marker.  This represents a second point on the
range and is used to specify a range.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
