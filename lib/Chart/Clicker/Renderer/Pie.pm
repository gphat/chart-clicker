package Chart::Clicker::Renderer::Pie;
use Moose;

extends 'Chart::Clicker::Renderer::Base';

use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::Stroke;
use Chart::Clicker::Shape::Arc;

has 'border_color' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Color',
    default => sub { new Chart::Clicker::Drawing::Color({ name => 'black' }) }
);
has 'stroke' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::Stroke',
    default => sub { new Chart::Clicker::Drawing::Stroke() }
);

my $TO_RAD = (4 * atan2(1, 1)) / 180;

sub prepare {
    my $self = shift();
    my $clicker = shift();

    $self->SUPER::prepare($clicker, @_);

    foreach my $ds (@{ $clicker->datasets() }) {
        foreach my $series (@{ $ds->series() }) {
            foreach my $val (@{ $series->values() }) {
                $self->{'ACCUM'}->{$series->name()} += $val;
                $self->{'TOTAL'} += $val;
            }
        }
    }

    $self->{'RADIUS'} = $self->height();
    if($self->width() < $self->height()) {
        $self->{'RADIUS'} = $self->width();
    }

    $self->{'RADIUS'} = $self->{'RADIUS'} / 2;

    # Take into acount the line around the edge when working out the radius
    $self->{RADIUS} -= $self->stroke->width();

    $self->{'MIDX'} = $self->width() / 2;
    $self->{'MIDY'} = $self->height() / 2;
    $self->{'POS'} = -90;
}

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

    my $midx = $self->{'MIDX'};
    my $midy = $self->{'MIDY'};

    my $avg = $self->{'ACCUM'}->{$series->name()} / $self->{'TOTAL'};
    my $degs = ($avg * 360) + $self->{'POS'};

    $cr->line_to($midx, $midy);

    $cr->arc_negative($midx, $midy, $self->{'RADIUS'}, $degs * $TO_RAD, $self->{'POS'} * $TO_RAD);
    $cr->line_to($midx, $midy);
    $cr->close_path();

    my $color = $clicker->color_allocator->next();

    $cr->set_source_rgba($color->rgba());
    $cr->fill_preserve();

    $cr->set_source_rgba($self->border_color->rgba());
    $cr->stroke();

    $self->{'POS'} = $degs;

    return 1;
}

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Pie

=head1 DESCRIPTION

Chart::Clicker::Renderer::Pie renders a dataset as slices of a pie.  The keys
of like-named Series are totaled and keys are ignored.

=head1 SYNOPSIS

  my $lr = new Chart::Clicker::Renderer::Pie();
  # Optionally set the stroke
  $lr->options({
    stroke => new Chart::Clicker::Drawing::Stroke({
      ...
    })
  });

=head1 OPTIONS

=over 4

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
