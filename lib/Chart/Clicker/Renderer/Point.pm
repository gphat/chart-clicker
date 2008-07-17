package Chart::Clicker::Renderer::Point;
use Moose;

extends 'Chart::Clicker::Renderer';

use Chart::Clicker::Shape::Arc;

has 'shape' => (
    is => 'rw',
    does => 'Chart::Clicker::Shape',
    default => sub {
        Chart::Clicker::Shape::Arc->new({
           radius => 3,
           angle1 => 0,
           angle2 => 360
        });
    }
);

override('draw', sub {
    my $self = shift();

    my $clicker = $self->clicker;
    my $cr = $clicker->cairo;

    my $dses = $clicker->get_datasets_for_context($self->context);
    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series }) {

            # TODO if undef...
            my $ctx = $clicker->get_context($ds->context);
            my $domain = $ctx->domain_axis;
            my $range = $ctx->range_axis;

            my $min = $range->range->lower();

            my $xper = $domain->per();
            my $yper = $range->per();
            my $height = $self->height();

            my @vals = @{ $series->values() };
            my @keys = @{ $series->keys() };
            for(0..($series->key_count() - 1)) {
                my $x = $domain->mark($keys[$_]);
                my $y = $height - $range->mark($vals[$_]);

                $cr->move_to($x, $y);
                $self->draw_point($cr, $x, $y, $series, $_);
            }
            my $color = $clicker->color_allocator->next();
            $cr->set_source_rgba($color->as_array_with_alpha());
            $cr->fill();
        }
    }

    return 1;
});

sub draw_point {
    my ($self, $cr, $x, $y, $series, $count) = @_;

    $self->shape->create_path($cr, $x , $y);
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Point

=head1 DESCRIPTION

Chart::Clicker::Renderer::Point renders a dataset as points.

=head1 SYNOPSIS

  my $pr = Chart::Clicker::Renderer::Point->new({
    shape => Chart::Clicker::Shape::Arc->new({
        angle1 => 0,
        angle2 => 180,
        radius  => 5
    })
  });

=head1 ATTRIBUTES

=over 4

=item I<shape>

Specify the shape to be used at each point.  Defaults to 360 degree arc with
a radius of 3.

=back

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Create a new Point renderer

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
