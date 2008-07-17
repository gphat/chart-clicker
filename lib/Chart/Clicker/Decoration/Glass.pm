package Chart::Clicker::Decoration::Glass;
use Moose;

extends 'Chart::Clicker::Decoration';

use Graphics::Color::RGB;

has 'background_color' => ( is => 'rw', isa => 'Graphics::Color::RGB' );
has 'glare_color' => (
    is => 'rw',
    isa => 'Graphics::Color::RGB',
    default => sub {
       Graphics::Color::RGB->new(
            red => 1, green => 1, blue => 1, alpha => 1
        )
    },
    coerce => 1
);

override('prepare', sub {
    my $self = shift();
    my $clicker = shift();
    my $dimension = shift();

    $self->width($dimension->width());
    $self->height($dimension->height());

    return 1;
});

override('draw', sub {
    my $self = shift();
    my $clicker = shift();

    my $cr = $clicker->cairo();

    if($self->background_color()) {
        $cr->set_source_rgba($self->background_color->as_array_with_alpha());
        $cr->fill();
    }

    my $twentypofheight = $self->height() * .20;

    $cr->move_to(1, $twentypofheight);
    $cr->rel_curve_to(
        0, 0, $self->width() / 2, -$self->height() * .30,
        $self->width(), 0
    );
    $cr->line_to($self->width(), 0);
    $cr->line_to(0, 0);
    $cr->line_to(0, $twentypofheight);

    $cr->set_source_rgba($self->glare_color->as_array_with_alpha());
    $cr->fill();
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::Glass

=head1 DESCRIPTION

A glass-like decoration.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Chart::Clicker::Decoration::Glass object.

=back

=head2 Instance Methods

=over 4

=item I<background_color>

Set/Get the background color for this glass.

=item I<draw>

Draw this Grid.

=item I<glare_color>

Set/Get the glare color for this glass.

=item I<prepare>

Prepare this Glass for drawing

=cut

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
