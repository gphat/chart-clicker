package Chart::Clicker::Renderer::Line;
use Moose;

extends 'Chart::Clicker::Renderer::Base';

use Chart::Clicker::Drawing::Stroke;

has 'shape' => (
    is => 'rw',
    isa => 'Chart::Clicker::Shape'
);
has 'shape_stroke' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Stroke',
);
has 'stroke' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Stroke',
    default => sub { new Chart::Clicker::Drawing::Stroke() }
);

sub draw {
    my $self = shift();
    my $clicker = shift();
    my $cr = shift();
    my $series = shift();
    my $domain = shift();
    my $range = shift();

    my $height = $self->height();
    my $linewidth = 1;

    $cr->set_line_cap($self->stroke->line_cap());
    $cr->set_line_join($self->stroke->line_join());
    $cr->set_line_width($self->stroke->width());

    $cr->new_path();

    my $color = $clicker->color_allocator->next();
    $cr->set_source_rgba($color->rgba());

    my @vals = @{ $series->values() };
    my @keys = @{ $series->keys() };

    my $kcount = $series->key_count() - 1;

    for(0..$kcount) {
        my $x = $domain->mark($keys[$_]);
        my $y = $height - $range->mark($vals[$_]);
        if($_ == 0) {
            $cr->move_to($x, $y);
        } else {
            $cr->line_to($x, $y);
        }
    }
    $cr->stroke();

    if(defined($self->shape())) {
        for(0..$kcount) {
            my $x = $domain->mark($keys[$_]);
            my $y = $height - $range->mark($vals[$_]);
            $self->shape->create_path($cr, $x, $y);

            if($self->shape_stroke()) {
                $cr->set_line_cap($self->shape_stroke->line_cap());
                $cr->set_line_join($self->shape_stroke->line_join());
                $cr->set_line_width($self->shape_stroke->width());
                $cr->stroke();
            } else {
                $cr->fill();
            }
        }
    }

    return 1;
}

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Line

=head1 DESCRIPTION

Chart::Clicker::Renderer::Line renders a dataset as lines.

=head1 SYNOPSIS

  my $lr = new Chart::Clicker::Renderer::Line(
    stroke => new Chart::Clicker::Drawing::Stroke({
      ...
    })
  });

=head1 ATTRIBUTES

=over 4

=item shape

Set a shape object to draw at each of the data points.

=item shape_stroke

Define the stroke to be used on the shapes at each point.  If no shape_stroke
is provided, then the shapes will be billed.

=item stroke

Set a Stroke object to be used for the lines.

=back

=head1 METHODS

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
