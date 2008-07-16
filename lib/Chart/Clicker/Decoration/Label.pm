package Chart::Clicker::Decoration::Label;
use Moose;

extends 'Chart::Clicker::Decoration';

use Graphics::Color::RGB;

use Graphics::Primitive::Font;
use Graphics::Primitive::Insets;

has 'color' => (
    is => 'rw',
    isa => 'Graphics::Color',
    default => sub {
        Graphics::Color::RGB->new(
            red => 0, green => 0, blue => 0, alpha => .30
        )
    },
    coerce => 1
);
has 'font' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Font',
    default => sub {
        Graphics::Primitive::Font->new()
    }
);
has '+orientation' => (
    required => 1
);
has 'text' => (
    is => 'rw',
    isa => 'Str'
);

my $VERTICAL = 4.71238898;

override('prepare', sub {
    my $self = shift();

    my $font = $self->font();

    my $cr = $self->clicker->cairo();

    $cr->select_font_face($font->face(), $font->slant(), $font->weight());
    $cr->set_font_size($font->size());

    my $orientation = $self->orientation();

    my $extents;
    if($self->is_vertical) {
        $cr->save();
        $cr->rotate($VERTICAL);
        $extents = $cr->text_extents($self->text());
        $extents->{total_height} = $extents->{height} - $extents->{y_bearing};
        $cr->restore();
        $self->minimum_width(
            $extents->{total_height} + $self->outside_width
        );
        $self->minimum_height($extents->{width});
    } else {
        $extents = $cr->text_extents($self->text());
        $extents->{total_height} = $extents->{height} - $extents->{y_bearing};
        $self->minimum_width($extents->{width});
        $self->minimum_height(
            $extents->{'total_height'} + $self->outside_height
        );
    }

    $self->{'EXTENTS'} = $extents;

    return 1;
});

override('draw', sub {
    my $self = shift();

    super;

    my $width = $self->width();
    my $height = $self->height();

    my $cr = $self->clicker->cairo();

    $cr->set_source_rgba($self->color->as_array_with_alpha());
    $cr->select_font_face(
        $self->font->face(), $self->font->slant(), $self->font->weight()
    );
    $cr->set_font_size($self->font->size());

    my $extents = $self->{'EXTENTS'};
    my ($x, $y);
    if($self->is_vertical) {
        $x = ($width / 2) + ($extents->{'height'} / 2);
        $y = ($height / 2) + ($extents->{'width'} / 2);
    } else {
        $x = ($width / 2) - ($extents->{'width'} / 2);
        $y = ($height / 2) + ($extents->{'height'} / 2);
    }

    $cr->move_to($x, $y);

    if($self->is_horizontal) {
        $cr->show_text($self->text());
    } else {
        $cr->save();
        $cr->rotate($VERTICAL);
        $cr->show_text($self->text());
        $cr->restore();
    }
});

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::Label

=head1 DESCRIPTION

Chart::Clicker::Decoration::Label draws text on the chart.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Label object.

=back

=head2 Instance Methods

=over 4

=item I<border>

Set/Get this Label's border.

=item I<color>

Set/Get the color of this label.

=item I<draw>

Draw this Label

=item I<font>

Set/Get the font for this label.

=item I<insets>

Set/Get this label's insets.

=item I<orientation>

Set/Get this label's orientation.

=item I<prepare>

Prepare this Label by determining how much space it needs.

=item I<text>

Set/Get this label's text.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
