package Chart::Clicker::Drawing::Component;
use Moose;

extends 'Graphics::Primitive::Component';

with 'Graphics::Primitive::Oriented';

use Geometry::Primitive::Point;
use Graphics::Primitive::Border;
use Graphics::Color::RGB;

has '+border' => (
    default => sub {
        Graphics::Primitive::Border->new(
            color => Graphics::Color::RGB->new()
        )
    }
);
has 'clicker' => (
    is => 'rw',
    isa => 'Chart::Clicker'
);
has '+origin' => (
    default => sub { Geometry::Primitive::Point->new(x => 0, y => 0) }
);

override('draw', sub {
    my $self = shift();

    my $width = $self->width();
    my $height = $self->height();

    my $context = $self->clicker->cairo();

    if(defined($self->background_color())) {
        $context->set_source_rgba($self->background_color->as_array_with_alpha());
        $context->rectangle(0, 0, $width, $height);
        $context->paint();
    }

    my $x = 0;
    my $y = 0;
    my $bwidth = $width;
    my $bheight = $height;

    my $margins = $self->margins();
    my ($mx, $my, $mw, $mh) = (0, 0, 0, 0);
    if($margins) {
        $mx = $margins->left();
        $my = $margins->top();
        $mw = $margins->right();
        $mh = $margins->bottom();
    }

    if(defined($self->border())) {
        my $stroke = $self->border();
        my $bswidth = $stroke->width();
        $context->set_source_rgba($self->border->color->as_array_with_alpha());
        $context->set_line_width($bswidth);
        $context->set_line_cap($stroke->line_cap());
        $context->set_line_join($stroke->line_join());
        $context->new_path();
        my $swhalf = $bswidth / 2;
        $context->rectangle(
            $mx + $swhalf, $my + $swhalf,
            $width - $bswidth - $mw - $mx, $height - $bswidth - $mh - $my
        );
        $context->stroke();
    }
});

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Drawing::Component

=head1 DESCRIPTION

A Component is an entity with a graphical representation.  Subclasses
L<Graphics::Primitive::Component>.

=head1 SYNOPSIS

  my $c = Chart::Clicker::Drawing::Component->new({
    location => Chart::Clicker::Drawing::Point->new({
        x => $x, y => $y
    }),
    width => 500, height => 350
  });

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

  my $c = Chart::Clicker::Drawing::Component->new({
    location => Chart::Clicker::Drawing::Point->new({
        x => $x, y => $y
    }),
    width => 500, height => 350
  });

Creates a new Component.

=back

=head2 Instance Methods

=over 4

=item I<clicker>

Get this Component's instance of Chart::Clicker.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1), L<Graphics::Primitive>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
