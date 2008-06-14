package Chart::Clicker::Drawing::Component;

use Moose;
use Moose::Util::TypeConstraints;

use Chart::Clicker::Drawing qw(:positions);
use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::Dimension;
use Chart::Clicker::Drawing::Insets;

use Cairo;

enum 'Orientations' => ($CC_HORIZONTAL, $CC_VERTICAL);
enum 'Positions' => ($CC_TOP, $CC_BOTTOM, $CC_LEFT, $CC_RIGHT );

has 'background_color' => ( is => 'rw', isa => 'Color', coerce => 1 );
has 'border' => ( is => 'rw', isa => 'Chart::Clicker::Drawing::Border' );
has 'color' => ( is => 'rw', isa => 'Color', coerce => 1 );
has 'height' => ( is => 'rw', isa => 'Num' );
has 'width' => ( is => 'rw', isa => 'Num' );
has 'location' => ( is => 'rw', isa => 'Chart::Clicker::Drawing::Point' );
has 'insets' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Insets',
    default => sub { new Chart::Clicker::Drawing::Insets() }
);
has 'margins' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Insets',
    default => sub { new Chart::Clicker::Drawing::Insets() }
);

sub dimensions {
    my $self = shift();

    return new Chart::Clicker::Drawing::Dimension({
        width => $self->width(), height => $self->height()
    });
}

sub draw {
    my $self = shift();
    my $clicker = shift();

    my $width = $self->width();
    my $height = $self->height();

    my $surface = $clicker->create_new_surface(
        $width, $height
    );
    my $context = Cairo::Context->create($surface);

    if(defined($self->background_color())) {
        $context->set_source_rgba($self->background_color->rgba());
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
        my $stroke = $self->border->stroke();;
        my $bswidth = $stroke->width();
        $context->set_source_rgba($self->border->color->rgba());
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

    return $surface;
}

sub inside_width {
    my $self = shift();

    my $w = $self->width();

    my $ins = $self->insets();
    if(defined($ins)) {
        $w -= $ins->left() + $ins->right()
    }
    my $marg = $self->margins();
    if(defined($marg)) {
        $w -= $marg->left() + $marg->right();
    }
    my $bord = $self->border();
    if(defined($bord)) {
        $w -= $bord->stroke->width() * 2;
    }

    return $w;
}

sub inside_dimensions {
    my $self = shift();

    return new Chart::Clicker::Drawing::Dimension({
        width   => $self->inside_width(),
        height  => $self->inside_height()
    });
}

sub inside_height {
    my $self = shift();

    my $h = $self->height();

    my $ins = $self->insets();
    if(defined($ins)) {
        $h -= $ins->bottom() + $ins->top();
    }
    my $marg = $self->margins();
    if(defined($marg)) {
        $h -= $marg->bottom() + $marg->top();
    }
    my $bord = $self->border();
    if(defined($bord)) {
        $h -= $bord->stroke->width() * 2;
    }

    return $h;
}

sub upper_left_inside_point {
    my $self = shift();

    my $point = new Chart::Clicker::Drawing::Point({ x => 0, y => 0 });

    if(defined($self->insets())) {
        $point->x($self->insets->left());
        $point->y($self->insets->top());
    }
    if(defined($self->border())) {
        $point->x($point->x() + $self->border->stroke->width());
        $point->y($point->y() + $self->border->stroke->width());
    }

    return $point;
}

sub upper_right_inside_point {
    my $self = shift();

    my $point = $self->upper_left_inside_point();
    $point->x($point->x() + $self->inside_width());

    return $point;
}

sub lower_left_inside_point {
    my $self = shift();

    my $point = $self->upper_left_inside_point();
    $point->y($point->y() + $self->inside_height());

    return $point;
}

1;
__END__

=head1 NAME

Chart::Clicker::Drawing::Component

=head1 DESCRIPTION

A Component is an entity with a graphical representation.

=head1 SYNOPSIS

  my $c = new Chart::Clicker::Drawing::Component({
    location => new Chart::Clicker::Drawing::Point({
        x => $x, y => $y
    }),
    width => 500, height => 350
  });

=head1 METHODS

=head2 Constructor

=over 4

=item new

  my $c = new Chart::Clicker::Drawing::Component({
    location => new Chart::Clicker::Drawing::Point({
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
