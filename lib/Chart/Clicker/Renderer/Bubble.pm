package Chart::Clicker::Renderer::Bubble;
use Moose;

extends 'Chart::Clicker::Renderer::Point';

override('draw_point', sub {
    my ($self, $cr, $x, $y, $series, $count) = @_;

    $self->shape->radius($series->get_size($count));
    $self->shape->create_path($cr, $x , $y);
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;

__END__

=head1 NAME

Chart::Clicker::Renderer::Bubble

=head1 DESCRIPTION

Chart::Clicker::Renderer::Bubble is a subclass of the Point renderer where
the points' radiuses are deteremined by the size value of a Series::Size.

=head1 SYNOPSIS

  my $pr = Chart::Clicker::Renderer::Bubble->new({
    shape => Chart::Clicker::Shape::Arc->new({
        angle1 => 0,
        angle2 => 180,
    })
  });

=head1 ATTRIBUTES

=over 4

=item I<shape>

Specify the shape to be used at each point.  Defaults to 360 degree arc.  The
radius will be determined by the size value of the series.

=back

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Create a new Bubble renderer

=back

=head2 Instance Methods

=over 4

=item I<render>

Render the series.

=item I<draw_point>

Called for each point.  Implemented as a separate method so that subclasses
such as Bubble may override the drawing.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.