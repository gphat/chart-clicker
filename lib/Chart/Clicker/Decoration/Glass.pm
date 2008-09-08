package Chart::Clicker::Decoration::Glass;
use Moose;

extends 'Chart::Clicker::Decoration';

use Graphics::Color::RGB;
use Graphics::Primitive::Operation::Fill;
use Graphics::Primitive::Paint::Solid;

has 'background_color' => ( is => 'rw', isa => 'Graphics::Color::RGB', default => sub { Graphics::Color::RGB->new(red => 1, green => 0, blue => 0, alpha => 1) });
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

# override('prepare', sub {
#     my $self = shift();
#     my $clicker = shift();
#     my $dimension = shift();
# 
#     $self->width($dimension->width());
#     $self->height($dimension->height());
# 
#     return 1;
# });

override('finalize', sub {
    my ($self) = @_;

    my $twentypofheight = $self->height * .20;

    $self->move_to(1, $twentypofheight);

    $self->rel_curve_to(
        0, 0,
        $self->width / 2, $self->height * .30,
        $self->width, 0
    );

    $self->line_to($self->width, 0);
    $self->line_to(0, 0);
    $self->line_to(0, $twentypofheight);

    my $fillop = Graphics::Primitive::Operation::Fill->new(
        paint => Graphics::Primitive::Paint::Solid->new(
            color => $self->glare_color
        )
    );
    $self->do($fillop);
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
