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
has 'clicker' => ( is => 'rw', isa => 'Chart::Clicker' );
has 'domain_brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub {
        Graphics::Primitive::Brush->new(
            color => Graphics::Color::RGB->new(
                red => 0, green => 0, blue => 0, alpha => .25
            ),
            width => 1
        )
    }
);
has 'range_brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub {
        Graphics::Primitive::Brush->new(
            color => Graphics::Color::RGB->new(
                red => 0, green => 0, blue => 0, alpha => .25
            ),
            width => 1
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

override('finalize', sub {
    my $self = shift();

    return unless ($self->show_domain || $self->show_range);

    my $clicker = $self->clicker;

    my $dflt = $clicker->get_context('default');
    my $daxis = $dflt->domain_axis;
    my $raxis = $dflt->range_axis;

    if($self->show_domain) {
        $self->draw_lines($daxis);
        my $dop = Graphics::Primitive::Operation::Stroke->new;
        $dop->brush($self->domain_brush);
        $self->do($dop);
    }

    if($self->show_range) {
        $self->draw_lines($raxis);
        my $rop = Graphics::Primitive::Operation::Stroke->new;
        $rop->brush($self->range_brush);
        $self->do($rop);
    }
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

=head2 new

Creates a new Chart::Clicker::Decoration::Grid object.

=head2 background_color

Set/Get the background_color for this Grid.

=head2 border

Set/Get the border for this Grid.

=head2 color

Set/Get the color for this Grid.

=head2 domain_brush

Set/Get the brush for inking the domain markers.

=head2 draw_lines

Called by pack, draws the lines for a given axis.

=head2 pack

Prepare this Grid for drawing

=head2 range_brush

Set/Get the brush for inking the range markers.

=head2 show_domain

Flag to show or not show the domain lines.

=head2 show_range

Flag to show or not show the range lines.

=head2 stroke

Set/Get the Stroke for this Grid.

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
