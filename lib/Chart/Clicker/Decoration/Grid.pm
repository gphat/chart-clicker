package Chart::Clicker::Decoration::Grid;
use Moose;

extends 'Chart::Clicker::Decoration';

use Graphics::Primitive::Stroke;
use Graphics::Color::RGB;

has '+background_color' => (
    default => sub {
        Graphics::Color::RGB->new(
            red => 0.9, green => 0.9, blue => 0.9, alpha => 1
        )
    }
);
has '+border' => ( default => sub { Graphics::Primitive::Border->new( width => 0 )});
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
has 'stroke' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Stroke',
    default => sub { Graphics::Primitive::Stroke->new( ) }
);

sub dontdraw {
    my $self = shift();

    return unless ($self->show_domain || $self->show_range);

    my $clicker = $self->clicker;
    my $cr = $clicker->cairo;

    $cr->set_source_rgba($self->background_color->as_array_with_alpha());
    $cr->paint();

    my $dflt = $clicker->get_context('default');
    my $daxis = $dflt->domain_axis;
    my $raxis = $dflt->range_axis;

    $self->draw_lines($cr, $daxis) if $self->show_domain;

    $self->draw_lines($cr, $raxis) if $self->show_range;

    $cr->set_source_rgba($self->color->as_array_with_alpha());
    my $stroke = $self->stroke();
    $cr->set_line_width($stroke->width());
    $cr->set_line_cap($stroke->line_cap());
    $cr->set_line_join($stroke->line_join());
    $cr->stroke();
}

sub draw_lines {
    my ($self, $cr, $axis) = @_;

    my $height = $self->height;
    my $width = $self->width;

    if($axis->is_horizontal) {

        foreach my $val (@{ $axis->tick_values() }) {
            $cr->move_to($axis->mark($width, $val), 0);
            $cr->rel_line_to(0, $height);
        }
    } else {

        foreach my $val (@{ $axis->tick_values() }) {
            $cr->move_to(0, $height - $axis->mark($height, $val));
            $cr->rel_line_to($width, 0);
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

=item I<draw>

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
