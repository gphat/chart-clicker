package Chart::Clicker::Renderer::Bubble;
use Moose;

# ABSTRACT: Bubble render

extends 'Chart::Clicker::Renderer::Point';

=head1 DESCRIPTION

Chart::Clicker::Renderer::Bubble is a subclass of the Point renderer where
the points' radiuses are determined by the size value of a Series::Size.

Note: B<This renderer requires you to use a
Chart::Clicker::Data::Series::Size>.

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/bubble.png" width="500" height="250" alt="Bubble Chart" /></p>

=end HTML

=head1 SYNOPSIS

  my $pr = Chart::Clicker::Renderer::Bubble->new({
    shape => Geometry::Primitive::Circle->new({
        radius => 3
    })
  });

=method draw_point

Called for each point.  Implemented as a separate method so that subclasses
such as Bubble may override the drawing.

=cut

override('draw_point', sub {
    my ($self, $x, $y, $series, $count) = @_;

    my $shape = $self->shape->scale($series->get_size($count));
    $shape->origin(Geometry::Primitive::Point->new(x => $x, y => $y));
    $self->path->add_primitive($shape);
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;