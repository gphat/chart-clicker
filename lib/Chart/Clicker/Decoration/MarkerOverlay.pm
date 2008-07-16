package Chart::Clicker::Decoration::MarkerOverlay;

use Moose;

extends 'Chart::Clicker::Decoration';

override('draw', sub {
    my $self = shift();

    my $cr = $self->clicker->cairo();

    my $width = $self->width();
    my $height = $self->height();

    foreach my $ctx (@{ $self->clicker->contexts }) {
        foreach my $marker (@{ $ctx->markers() }) {

            my $key = $marker->key();
            my $key2 = $marker->key2();
            my $value = $marker->value();
            my $value2 = $marker->value2();

            $cr->set_line_width($marker->stroke->width());
            $cr->set_source_rgba($marker->color->rgba());

            if($key && $value) {
            } elsif(defined($key)) {
                my $domain = $ctx->domain_axis;

                my $x = $domain->mark($key);
                my $x2;

                if($key2) {
                    $x2 = $domain->mark($key2);
                    $cr->rectangle($x, 0, ($x2 - $x), $height);
                    $cr->save();
                    $cr->set_source_rgba($marker->inside_color->as_array_with_alpha());
                    $cr->fill();
                    $cr->restore();
                }

                $cr->move_to($x, 0);
                $cr->rel_line_to(0, $height);

                if($x2) {
                    $cr->move_to($x2, 0);
                    $cr->rel_line_to(0, $height);
                }

                $cr->stroke();
            } elsif(defined($value)) {
                my $range = $ctx->range_axis;

                my $y = $range->mark($value);
                my $y2;

                if($value2) {
                    $y2 = $range->mark($value2);
                    $cr->rectangle(0, $y, $width, ($y2 - $y));
                    $cr->save();
                    $cr->set_source_rgba($marker->inside_color->as_array_with_alpha());
                    $cr->fill();
                    $cr->restore();
                }

                $cr->move_to(0, $y);
                $cr->rel_line_to($width, 0);

                if($y2) {
                    $cr->move_to(0, $y2);
                    $cr->rel_line_to($width, 0);
                }
                $cr->stroke();
            }
        }
    }
});

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::MarkerOverlay

=head1 DESCRIPTION

A Component that handles the rendering of Markers.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new MarkerOverlay object.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
