package Chart::Clicker::Decoration::Grid;
use Moose;

extends 'Chart::Clicker::Decoration';

has '+background_color' => (
    default => sub {
        new Chart::Clicker::Drawing::Color(
            red => 0.9, green => 0.9, blue => 0.9, alpha => 1
        )
    }
);
has '+color' => (
    default => sub {
        new Chart::Clicker::Drawing::Color(
            red => 0, green => 0, blue => 0, alpha => .30
        )
    }
);
has 'stroke' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Stroke',
    default => sub { new Chart::Clicker::Drawing::Stroke() }
);

use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::Stroke;

use Cairo;

sub prepare {
    my $self = shift();
    my $clicker = shift();
    my $dimension = shift();

    $self->width($dimension->width());
    $self->height($dimension->height());

    return 1;
}

sub draw {
    my $self = shift();
    my $clicker = shift();

    my $surface = $self->SUPER::draw($clicker);
    my $cr = Cairo::Context->create($surface);

    $cr->set_source_rgba($self->background_color->rgba());
    $cr->paint();

    my $daxis = $clicker->domain_axes->[0];
    my $raxis = $clicker->range_axes->[0];

    # Make the grid

    my $per = $daxis->per();
    my $height = $self->height();
    foreach my $val (@{ $daxis->tick_values() }) {
        $cr->move_to($daxis->mark($val), 0);
        $cr->rel_line_to(0, $height);
    }

    $per = $raxis->per();
    my $width = $self->width();
    foreach my $val (@{ $raxis->tick_values() }) {
        $cr->move_to(0, $height - $raxis->mark($val));
        $cr->rel_line_to($width, 0);
    }

    $cr->set_source_rgba($self->color->rgba());
    my $stroke = $self->stroke();
    $cr->set_line_width($stroke->width());
    $cr->set_line_cap($stroke->line_cap());
    $cr->set_line_join($stroke->line_join());
    $cr->stroke();

    return $surface;
}

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

=item new

Creates a new Chart::Clicker::Decoration::Grid object.

=back

=head2 Class Methods

=over 4

=item prepare

Prepare this Grid for drawing

=item color

Set/Get the color for this Grid.

=item domain_ticks

Set/Get the domain ticks for this Grid.

=item range_ticks

Set/Get the range ticks for this Grid.

=item stroke

Set/Get the Stroke for this Grid.

=item draw

Draw this Grid.

=cut

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
