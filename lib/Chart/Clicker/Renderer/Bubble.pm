package Chart::Clicker::Renderer::Bubble;
use Moose;

extends 'Chart::Clicker::Renderer::Point';

override('draw_point', sub {
    my ($self, $x, $y, $series, $count) = @_;

    my $shape = $self->shape->clone;
    $shape->origin(Geometry::Primitive::Point->new(x => $x, y => $y));
    $self->shape->scale($series->get_size($count));
    $self->path->add_primitive($shape);
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;

__END__

=head1 NAME

Chart::Clicker::Renderer::Bubble

=head1 DESCRIPTION

Chart::Clicker::Renderer::Bubble is a subclass of the Point renderer where
the points' radiuses are determined by the size value of a Series::Size.

Note: B<This renderer requires you to use a
Chart::Clicker::Data::Series::Size>.

=head1 SYNOPSIS

  my $pr = Chart::Clicker::Renderer::Bubble->new({
    shape => Chart::Clicker::Shape::Arc->new({
        angle1 => 0,
        angle2 => 180,
    })
  });

=head1 METHODS

=head2 Constructor

=head2 new

Create a new Bubble renderer

=head2 draw_point

Called for each point.  Implemented as a separate method so that subclasses
such as Bubble may override the drawing.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.