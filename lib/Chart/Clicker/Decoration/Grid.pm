package Chart::Clicker::Decoration::Grid;
use Moose;

extends 'Graphics::Primitive::Canvas';

with 'Graphics::Primitive::Oriented';

use Graphics::Color::RGB;

has '+background_color' => (
    default => sub {
        Graphics::Color::RGB->new(
            red => 0.9, green => 0.9, blue => 0.9, alpha => 1
        )
    }
);
has 'brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub { Graphics::Primitive::Brush->new(width => 1) }
);
has 'clicker' => ( is => 'rw', isa => 'Chart::Clicker' );
has '+color' => (
    default => sub {
        Graphics::Color::RGB->new(
            red => 0, green => 0, blue => 0, alpha => .30
        )
    }
);
has 'show_domain' => (
    is => 'rw',
    isa => 'Bool',
    default => 1
);
has 'show_range' => (
    is => 'rw',
    isa => 'Bool',
    default => 1
);

override('pack', sub {
    my $self = shift();

    return unless ($self->show_domain || $self->show_range);

    my $clicker = $self->clicker;

    my $dflt = $clicker->get_context('default');
    my $daxis = $dflt->domain_axis;
    my $raxis = $dflt->range_axis;

    $self->draw_lines($daxis) if $self->show_domain;

    $self->draw_lines($raxis) if $self->show_range;

    my $op = Graphics::Primitive::Operation::Stroke->new;
    $op->brush($self->brush);
    $op->brush->color($self->color);
    $self->do($op);
});

sub draw_lines {
    my ($self, $axis) = @_;

    my $height = $self->height;
    my $width = $self->width;

    if($axis->is_horizontal) {

        foreach my $val (@{ $axis->tick_values }) {
            $self->move_to($axis->mark($width, $val), 0);
            $self->rel_line_to(0, $height);
        }
    } else {

        foreach my $val (@{ $axis->tick_values }) {
            $self->move_to(0, $height - $axis->mark($height, $val));
            $self->rel_line_to($width, 0);
        }
    }
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::Grid

=head1 DESCRIPTION

Generates a collection of Markers for use as a background.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Chart::Clicker::Decoration::Grid object.

=back

=head2 Methods

=over 4

=item I<background_color>

Set/Get the background_color for this Grid.

=item I<border>

Set/Get the border for this Grid.

=item I<color>

Set/Get the color for this Grid.

=item I<draw_lines>

Called by pack, draws the lines for a given axis.

=item I<pack>

Prepare this Grid for drawing

=item I<show_domain>

Flag show or not show the domain lines.

=item I<show_range>

Flag show or not show the range lines.

=item I<stroke>

Set/Get the Stroke for this Grid.

=cut

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
