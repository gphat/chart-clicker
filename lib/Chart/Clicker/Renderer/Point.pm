package Chart::Clicker::Renderer::Point;
use Moose;

extends 'Chart::Clicker::Renderer::Base';

use Chart::Clicker::Shape::Arc;

has 'shape' => (
    is => 'rw',
    isa => 'Chart::Clicker::Shape',
    default => sub {
        new Chart::Clicker::Shape::Arc({
           radius => 3,
           angle1 => 0,
           angle2 => 360
        });
    }
);

sub draw {
    my $self = shift();
    my $clicker = shift();
    my $cr = shift();
    my $series = shift();
    my $domain = shift();
    my $range = shift();

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
        $self->shape->create_path($cr, $x , $y);
    }
    my $color = $clicker->color_allocator->next();
    $cr->set_source_rgba($color->rgba());
    $cr->fill();

    return 1;
}

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Point

=head1 DESCRIPTION

Chart::Clicker::Renderer::Point renders a dataset as points.

=head1 SYNOPSIS

  my $pr = new Chart::Clicker::Renderer::Point({
    shape => new Chart::Clicker::Shape::Arc({
        angle1 => 0,
        angle2 => 180,
        radius  => 5
    })
  });

=head1 ATTRIBUTES

=over 4

=item shape

Specify the shape to be used at each point.  Defaults to 360 degree arc with
a radius of 3.

=back

=head1 METHODS

=head2 Constructor

=over 4

=item new

Create a new Point renderer

=back

=head2 Class Methods

=over 4

=item render

Render the series.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
