package Chart::Clicker::Decoration::Legend::Tabular;
use Moose;

extends 'Chart::Clicker::Decoration::Legend';

# ABSTRACT: Tabular version of Legend

use Graphics::Primitive::Font;
use Graphics::Primitive::Insets;
use Graphics::Primitive::TextBox;
use Graphics::Color::RGB;

use Layout::Manager::Grid;

=head1 DESCRIPTION

Chart::Clicker::Decoration::Legend::Tabular draws a legend on a Chart with
tabular data display.

The Tabular legend is a legend with a few extra attributes that allow you to
pass it data to display.  The attributes are c<header> and c<data>.  The
C<header> (optional) allows you to specify the strings to display at the top
of the table and the C<data> attribute allows you to pass in arrayrefs of
strings for display aside each of the series.

B<Note>: The first string in the C<header> arrayref should be the header for
the column above the name of the series.  This code does not do anything
to verify that you've given the appropriate counts of data.  It is expected
that you will provide C<data> with one arrayref for every series, each
containing n elements.  Having that, C<header> will expect n + 1 elements
with one for the series name and the remaining (n) matching the number of
elements in each of C<data>'s arrayrefs.

=head1 SYNOPSIS

    my $cc = Chart::Clicker->new;

    my $series1 = Chart::Clicker::Data::Series->new;
    my $series2 = Chart::Clicker::Data::Series->new;

    $cc->legend(Chart::Clicker::Decoration::Legend::Tabular->new(
        header => [ qw(Name Min Max) ],
        data => [
            [ min(@{ $series1->values }), max(@{ $series1->values }) ],
            [ min(@{ $series2->values }), max(@{ $series2->values }) ]
        ]
    ));

=attr border

Set/Get this Legend's border.

=cut

has '+border' => (
    default => sub {
        my $b = Graphics::Primitive::Border->new;
        $b->color(Graphics::Color::RGB->new( red => 0, green => 0, blue => 0));
        $b->width(1);
        return $b;
    }
);

=attr color

Set/Get the color to use as the foreground for the legend.

=cut

has '+color' => (
    default => sub { Graphics::Color::RGB->new( red => 0, green => 0, blue => 0) }
);

=attr data

Set/Get the data for this legend.  Expects an arrayref of arrayrefs, with
one inner arrayref for every series charted.

=cut

has 'data'  => (
    is => 'rw',
    isa => 'ArrayRef[ArrayRef[Str]]',
    required => 1
);

=attr font

Set/Get the font used for this legend's items.

=cut

has 'font' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Font',
    default => sub {
        Graphics::Primitive::Font->new
    }
);

=attr header

Set/Get the header data used for this legend.  Expects an arrayref of Strings.

=method has_header

Predicate returning true of this legend has a header, else 1.

=cut

has 'header' => (
    is => 'rw',
    isa => 'ArrayRef[Str]',
    predicate => 'has_header'
);

=attr insets

Set/Get this Legend's insets.

=attr item_padding

Set/Get the padding for this legend's items.

=cut

has 'item_padding' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Insets',
    default => sub {
        Graphics::Primitive::Insets->new({
            top => 3, left => 3, bottom => 3, right => 5
        })
    }
);
has '+layout_manager' => (
    default => sub {
        my $self = shift;
        my $header_rows = $self->has_header ? 1 : 0;
        return Layout::Manager::Grid->new(
            rows => scalar(@{ $self->data }) + $header_rows,
            columns => scalar(@{ $self->data->[0] }) + 1
        );
    },
    lazy => 1
);

override('prepare', sub {
    my ($self, $driver) = @_;

    return if $self->component_count > 0;

    my $ca = $self->clicker->color_allocator;

    my $font = $self->font;

    my $ii = $self->item_padding;

    if($self->is_vertical) {
        # This assumes you aren't changing the layout manager...
        $self->layout_manager->anchor('north');
    }

    my $row_offset = 0;
    if($self->has_header) {
        $row_offset = 1;
        my $count = 0;
        # foreach my $d (@{ $self->header }) {
        for(0..scalar(@{ $self->header }) - 1) {
            $self->add_component(
                Graphics::Primitive::TextBox->new(
                    color => $self->color,
                    font => $font,
                    padding => $ii,
                    text => $self->header->[$_]
                ),
                { row => 0, column => $_ }
            );
            $count++;
        }
    }

    my @data = @{ $self->data };

    my $count = 0;
    foreach my $ds (@{ $self->clicker->datasets }) {
        foreach my $s (@{ $ds->series }) {

            my $color = $ca->next;

            unless($s->has_name) {
                $s->name("Series $count");
            }

            my $tb = Graphics::Primitive::TextBox->new(
                color => $color,
                font => $font,
                padding => $ii,
                text => $s->name
            );

            $self->add_component($tb, { row => $count + $row_offset, column => 0 });

            for(0..scalar(@{ $data[$count] }) - 1) {
                $self->add_component(
                    Graphics::Primitive::TextBox->new(
                        color => $color,
                        font => $font,
                        padding => $ii,
                        text => $data[$count]->[$_]
                    ),
                    { row => $count + $row_offset, column => $_ + 1 }
                );
            }

            $count++;
        }
    }

    super;

    $ca->reset;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;