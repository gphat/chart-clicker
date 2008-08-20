package Chart::Clicker::Decoration::MarkerOverlay;

use Moose;

extends 'Chart::Clicker::Decoration';

use Graphics::Primitive::Operation::Stroke;
use Graphics::Primitive::Operation::Fill;
use Graphics::Primitive::Paint::Solid;

override('pack', sub {
    my ($self) = @_;

    my $width = $self->width;
    my $height = $self->height;

    my $clicker = $self->clicker;

    foreach my $cname ($clicker->context_names) {
        my $ctx = $clicker->get_context($cname);
        foreach my $marker (@{ $ctx->markers }) {

            my $key = $marker->key;
            my $key2 = $marker->key2;
            my $value = $marker->value;
            my $value2 = $marker->value2;

            if($key && $value) {
            } elsif(defined($key)) {
                my $domain = $ctx->domain_axis;

                my $x = $domain->mark($self->width, $key);
                my $x2;

                if($key2) {
                    $x2 = $domain->mark($self->width, $key2);
                    $self->move_to($x, 0);
                    $self->rectangle(($x2 - $x), $height);
                    my $fillop = Graphics::Primitive::Operation::Fill->new(
                        paint => Graphics::Primitive::Paint::Solid->new(
                            color => $marker->inside_color
                        ),
                    );
                    $self->do($fillop);
                }

                $self->move_to($x, 0);
                $self->rel_line_to(0, $height);

                if($x2) {
                    $self->move_to($x2, 0);
                    $self->rel_line_to(0, $height);
                }

                my $op = Graphics::Primitive::Operation::Stroke->new;
                $op->brush($marker->brush);

                $self->do($op);
            } elsif(defined($value)) {
                my $range = $ctx->range_axis;
                # 
                my $y = $range->mark($height, $value);
                my $y2;

                if($value2) {
                    $y2 = $range->mark($self->height, $value2);
                    $self->move_to(0, $y);
                    $self->rectangle($width, ($y2 - $y));
                    my $fillop = Graphics::Primitive::Operation::Fill->new(
                        paint => Graphics::Primitive::Paint::Solid->new(
                            color => $marker->inside_color
                        ),
                    );
                    $self->do($fillop);

                }

                $self->move_to(0, $y);
                $self->rel_line_to($width, 0);

                if($y2) {
                    $self->move_to(0, $y2);
                    $self->rel_line_to($width, 0);
                }

                my $op = Graphics::Primitive::Operation::Stroke->new;
                $op->brush($marker->brush);

                $self->do($op);
            }
        }
    }
});

__PACKAGE__->meta->make_immutable;

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
