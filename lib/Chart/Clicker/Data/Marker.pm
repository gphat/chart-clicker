package Chart::Clicker::Data::Marker;
use Moose;

# ABSTRACT: Highlight arbitrary value(s)

use Graphics::Color::RGB;
use Graphics::Primitive::Brush;

=head1 DESCRIPTION

Used to highlight a particular key, value or range of either.

=head1 SYNOPSIS

 use Chart::Clicker::Data::Marker;
 use Graphics::Color::RGB;
 use Graphics::Primitive::Brush;

 my $cc = Chart::Clicker->new;

 my $mark = Chart::Clicker::Data::Marker->new(
    color   => Graphics::Color::RGB->new,
    brush  => Graphics::Primitive::Brush->new,
    key     => 12,
    value   => 123,
    # Optionally
    key2    => 13,
    value   => 146
 );

 my $ctx = $cc->get_context('default');
 $ctx->add_marker($mark);
 
 $cc->write_output('foo.png');

=attr brush

Set/Get the L<brush|Graphics::Primitive::Brush> for this Marker.

=cut

has 'brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub {
        Graphics::Primitive::Brush->new(width => 1);
    }
);

=attr color

Set/Get the L<color|Graphics::Primitive::Color> for this marker.

=cut

has 'color' => (
    is => 'rw',
    isa => 'Graphics::Color',
    default => sub {
        Graphics::Color::RGB->new(
            red => 0, green => 0, blue => 0, alpha => 1
        );
    }
);

=attr inside_color

Set/Get the inside L<color|Graphics::Primitive::Color>, which will be used if this range has two keys and
two values.

=cut

has 'inside_color' => (
    is => 'rw',
    isa => 'Graphics::Color',
    default => sub {
        Graphics::Color::RGB->new(
            red => 0, green => 0, blue => 0, alpha => 1
        );
    }
);

=attr key

Set/Get the key for this marker.  This represents a point on the domain.

=cut

has 'key' => ( is => 'rw', isa => 'Num' );

=attr key2

Set/Get the key2 for this marker.  This represents a second point on the domain
and is used to specify a range.

=cut

has 'key2' => ( is => 'rw', isa => 'Num' );

=attr value

Set/Get the value for this marker.  This represents a point on the range.

=cut

has 'value' => ( is => 'rw', isa => 'Num' );

=head2 value2

Set/Get the value2 for this marker.  This represents a second point on the
range and is used to specify a range.

=cut

has 'value2' => ( is => 'rw', isa => 'Num' );

__PACKAGE__->meta->make_immutable;

no Moose;

1;