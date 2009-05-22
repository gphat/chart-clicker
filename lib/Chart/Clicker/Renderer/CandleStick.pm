package Chart::Clicker::Renderer::CandleStick;
use Moose;

extends 'Chart::Clicker::Renderer';

use Graphics::Primitive::Brush;
use Graphics::Primitive::Operation::Fill;
use Graphics::Primitive::Operation::Stroke;
use Graphics::Primitive::Paint::Solid;

use List::Util qw(max min);

has 'bar_padding' => (
    is => 'rw',
    isa => 'Int',
    default => 0
);
has 'brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub { Graphics::Primitive::Brush->new(width => 2) }
);

override('prepare', sub {
    my $self = shift();

    super;

    my $datasets = $self->clicker->get_datasets_for_context($self->context);

    $self->{SCOUNT} = 1;
    $self->{KEYCOUNT} = 0;
    foreach my $ds (@{ $datasets }) {
        $self->{SCOUNT} += $ds->count;
        if($ds->max_key_count > $self->{KEYCOUNT}) {
            $self->{KEYCOUNT} = $ds->max_key_count;
        }
    }

    return 1;
});

override('finalize', sub {
    my ($self) = @_;

    my $clicker = $self->clicker;

    my $width = $self->width;
    my $height = $self->height;

    my $dses = $clicker->get_datasets_for_context($self->context);

    my $padding = $self->bar_padding + $self->brush->width;

    my $bwidth = int(($width / $dses->[0]->max_key_count)) - $self->bar_padding;
    my $hbwidth = int($bwidth / 2);

    my $scounter = $self->{SCOUNT};
    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series }) {

            my $color = $clicker->color_allocator->next;

            # TODO if undef...
            my $ctx = $clicker->get_context($ds->context);
            my $domain = $ctx->domain_axis;
            my $range = $ctx->range_axis;

            my $ocbwidth = $bwidth - ($bwidth * $domain->fudge_amount);
            my $cbwidth = $ocbwidth / $self->{SCOUNT};
            my $hcbwidth = $cbwidth / 2;
            my $offset = $bwidth - ($bwidth / $self->{SCOUNT});

            my $min = $range->range->lower;

            my $height = $self->height;

            my @highs = @{ $series->highs };
            my @lows = @{ $series->lows };
            my @opens = @{ $series->opens };
            my @vals = @{ $series->values };

            my @keys = @{ $series->keys };
            for(0..($series->key_count - 1)) {
                my $x = $domain->mark($width, $keys[$_]);

                $x -= $cbwidth * $scounter;
                $x += $offset;

                my $openy = $height - $range->mark($height, $opens[$_]);
                my $closey = $height - $range->mark($height, $vals[$_]);
                my $highy = $height - $range->mark($height, $highs[$_]);
                my $lowy = $height - $range->mark($height, $lows[$_]);

                my $height = $closey - $openy;

                $self->move_to($x - $hcbwidth, $openy);
                $self->rectangle(
                    $cbwidth, $height
                );

                my $op;
                if($height < 0) {
                    # We fill the bar if it closed higher
                    $op = Graphics::Primitive::Operation::Fill->new(
                        paint => Graphics::Primitive::Paint::Solid->new(
                           color => $color
                        )
                    );
                } else {
                    # We stroke the bar if it closed lower
                    $op = Graphics::Primitive::Operation::Stroke->new(
                        brush => $self->brush->clone
                    );
                    $op->brush->color($color);
                    $op->brush->width(2);
                }
                $self->do($op);

                $self->move_to($x, min($openy, $closey));
                $self->line_to($x, $highy);

                $self->move_to($x, max($openy, $closey));
                $self->line_to($x, $lowy);

                my $lineop = Graphics::Primitive::Operation::Stroke->new(
                    brush => $self->brush->clone
                );
                $lineop->brush->color($color);

                $self->do($lineop);

            }

            $scounter--;
        }
    }

    return 1;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::CandleStick

=head1 DESCRIPTION

Chart::Clicker::Renderer::CandleStick renders a dataset as a candlestick style
bar chart.

=head1 SYNOPSIS

  my $br = Chart::Clicker::Renderer::CandleStick->new();

=head1 METHODS

=head2 bar_padding

How much padding to put around a bar.  A padding of 4 will result in 2 pixels
on each side.

=head2 brush

Set/Get the Brush to use around each bar and on each line.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1), L<http://en.wikipedia.org/wiki/Candlestick_chart>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
