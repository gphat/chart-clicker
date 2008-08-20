package Chart::Clicker::Data::Marker;
use Moose;

use Graphics::Color::RGB;
use Graphics::Primitive::Brush;

has 'brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub {
        Graphics::Primitive::Brush->new(width => 1);
    }
);
has 'color' => (
    is => 'rw',
    isa => 'Graphics::Color',
    default => sub {
        Graphics::Color::RGB->new(
            red => 0, green => 0, blue => 0, alpha => 1
        );
    }
);
has 'inside_color' => (
    is => 'rw',
    isa => 'Graphics::Color',
    default => sub {
        Graphics::Color::RGB->new(
            red => 0, green => 0, blue => 0, alpha => 1
        );
    }
);
has 'key' => ( is => 'rw', isa => 'Num' );
has 'key2' => ( is => 'rw', isa => 'Num' );
has 'value' => ( is => 'rw', isa => 'Num' );
has 'value2' => ( is => 'rw', isa => 'Num' );

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::Marker

=head1 DESCRIPTION

Used to highlight a particular key, value or range of either.

=head1 SYNOPSIS

 use Chart::Clicker::Decoration::Marker;
 use Graphics::Color::RGB;
 use Graphics::Primitive::Brush;

 my $mark = Chart::Clicker::Decoration::Marker->new(
    color   => Graphics::Color::RGB->new,
    brush  => Graphics::Primitive::Brush->new,
    key     => 12,
    value   => 123,
    # Optionally
    key2    => 13,
    value   => 146
 );

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

=back

=head2 Instance Methods

=over 4

=item I<brush>

Set/Get the brush for this Marker.

=item I<color>

Set/Get the color for this marker.

=item I<key>

Set/Get the key for this marker.  This represents a point on the domain.

=item I<key2>

Set/Get the key2 for this marker.  This represents a second point on the domain
and is used to specify a range.

=item I<value>

Set/Get the value for this marker.  This represents a point on the range.

=item I<value2>

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
