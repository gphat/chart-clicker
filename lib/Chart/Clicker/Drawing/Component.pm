package Chart::Clicker::Drawing::Component;
use Moose;

extends 'Graphics::Primitive::Component';

has 'context' => (
    is => 'rw',
    isa => 'Chart::Clicker::Context'
);

override('draw', sub {
    my $self = shift();

    my $width = $self->width();
    my $height = $self->height();

    my $context = $self->context();

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

1;
__END__

=head1 NAME

Chart::Clicker::Drawing::Component

=head1 DESCRIPTION

A Component is an entity with a graphical representation.

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

=item new

  my $c = Chart::Clicker::Drawing::Component->new({
    location => Chart::Clicker::Drawing::Point->new({
        x => $x, y => $y
    }),
    width => 500, height => 350
  });

Creates a new Component.

=back

=head2 Class Methods

=over 4

=item dimensions

Get this Component's dimensions.

=item draw

Draw this component.

=item inside_width

Get the width available in this container after taking away space for
insets and borders.

=item inside_dimension

Get the dimension of this container's inside.

=item inside_height

Get the height available in this container after taking away space for
insets and borders.

=item height

Set/Get this Component's height

=item location

Set/Get this Component's location

=item width

Set/Get this Component's height

=item upper_left_inside_point

Get the Point for this container's upper left inside.

=item upper_right_inside_point

Get the Point for this container's upper right inside.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
