package Chart::Clicker::Decoration::Label;
use Moose;

extends 'Chart::Clicker::Decoration';

use Chart::Clicker::Context;
use Chart::Clicker::Drawing qw(:positions);

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

has 'text' => (
    is => 'rw',
    isa => 'Str'
);

my $VERTICAL = 4.71238898;

sub prepare {
    my $self = shift();
    my $clicker = shift();
    my $dimension = shift();

    my $font = $self->font();

    my $cr = $clicker->context();

    $cr->select_font_face($font->face(), $font->slant(), $font->weight());
    $cr->set_font_size($font->size());

    my $insets = $self->insets();

    my $orientation = $self->orientation();

    my $extents;
    if($orientation == $CC_VERTICAL) {
        $cr->save();
        $cr->rotate($VERTICAL);
        $extents = $cr->text_extents($self->text());
        $extents->{total_height} = $extents->{height} - $extents->{y_bearing};
        $cr->restore();
        $self->width(
            $extents->{'total_height'} + $insets->left() + $insets->right()
        );
        $self->height($dimension->height());
    } else {
        $extents = $cr->text_extents($self->text());
        $extents->{total_height} = $extents->{height} - $extents->{y_bearing};
        $self->width($dimension->width());
        $self->height(
            $extents->{'total_height'} + $insets->top() + $insets->bottom()
        );
    }

    $self->{'EXTENTS'} = $extents;

    return 1;
}

sub draw {
    my $self = shift();
    my $clicker = shift();

    my $width = $self->width();
    my $height = $self->height();

    my $cr = $clicker->context();

    $cr->set_source_rgba($self->color->rgba());
    $cr->select_font_face(
        $self->font->face(), $self->font->slant(), $self->font->weight()
    );
    $cr->set_font_size($self->font->size());

    my $extents = $self->{'EXTENTS'};
    my $insets = $self->insets();
    my ($x, $y);
    if($self->orientation() == $CC_HORIZONTAL) {
        $x = ($width / 2) - ($extents->{'width'} / 2);
        $y = ($height / 2) + ($extents->{'height'} / 2);
    } else {
        $x = ($width / 2) + ($extents->{'height'} / 2);
        $y = ($height / 2) + ($extents->{'width'} / 2);
    }

    $cr->move_to($x, $y);

    if($self->orientation() == $CC_VERTICAL) {
        $cr->save();
        $cr->rotate($VERTICAL);
        $cr->show_text($self->text());
        $cr->restore();
    } else {
        $cr->show_text($self->text());
    }
}

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

=head2 Methods

=over 4

=item I<border>

Set/Get this Label's border.

=item I<insets>

Set/Get this Label's insets.

=item I<draw>

Draw this Label

=item I<prepare>

Prepare this Label by determining how much space it needs.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
