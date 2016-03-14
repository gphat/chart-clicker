package Chart::Clicker::Decoration::Annotation;

$Chart::Clicker::Decoration::Annotation::VERSION = '2.88';

use strict;
use warnings;
use Moose;

use Graphics::Color::RGB;
use Geometry::Primitive::Point;
use Layout::Manager::Absolute;

extends 'Chart::Clicker::Container';

has '+background_color' => (
    default => sub {
        Graphics::Color::RGB->new(
            red   => 1,
            green => 1,
            blue  => 1,
            alpha => 1
        );
    },
);

has 'color' => (
    is      => 'rw',
    isa     => 'Graphics::Color::RGB',
    default => sub {
        Graphics::Color::RGB->new(
            red   => 0,
            green => 0,
            blue  => 0,
            alpha => 1
        );
    },
);

has 'key' => (
    is       => 'rw',
    isa      => 'Num',
    required => 1,
);

has 'value' => (
    is       => 'rw',
    isa      => 'Num',
    required => 1,
);

has 'offset' => (
    is      => 'rw',
    isa     => 'Geometry::Primitive::Point',
    default => sub { Geometry::Primitive::Point->new( x => 0, y => 0 ) }
);

has 'text' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

has 'context' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

has 'font' => (
    is      => 'rw',
    isa     => 'Graphics::Primitive::Font',
    default => sub { Graphics::Primitive::Font->new }
);

has '+layout_manager' =>
  ( ( default => sub { Layout::Manager::Absolute->new } ), );

override(
    'prepare',
    sub {
        my ( $self, $driver ) = @_;

        my $tb = Graphics::Primitive::TextBox->new(
            text  => $self->text,
            color => $self->color,
            font  => $self->font,
        );
        my $lay = $driver->get_textbox_layout($tb);
        $tb->width( $lay->width );
        $tb->height( $lay->height );
        $tb->origin->x( $self->border->left->width + $self->padding->left );
        $tb->origin->y( $self->border->top->width + $self->padding->top );
        $self->add_component( $tb, 'c' );
        super;
    }
);

override(
    'finalize',
    sub {
        my ($self) = @_;

        my $ctx    = $self->clicker->get_context( $self->context );
        my $domain = $ctx->domain_axis;
        my $range  = $ctx->range_axis;

        my $tb = $self->get_component(0);
        my $width =
          $tb->width +
          $self->border->left->width +
          $self->border->right->width +
          $self->padding->left +
          $self->padding->right;
        my $height =
          $tb->height +
          $self->border->top->width +
          $self->border->bottom->width +
          $self->padding->top +
          $self->padding->bottom;
        $self->minimum_width($width);
        $self->width($width);
        $self->minimum_height($height);
        $self->height($height);

        my $plot        = $self->clicker->plot;
        my $render_area = $plot->render_area;

        $self->origin->x( ( $self->key - $domain->range->lower ) /
              ( $domain->range->upper - $domain->range->lower ) *
              $render_area->width + $self->offset->x );
        $self->origin->y( ( $range->range->upper - $self->value ) /
              ( $range->range->upper - $range->range->lower ) *
              $render_area->height + $self->offset->y );
    }
);

__PACKAGE__->meta->make_immutable;

no Moose;

1;

__END__

=pod
 
=head1 NAME
 
Chart::Clicker::Decoration::Annotation - Text annotation over data
 
=head1 VERSION
 
version 2.88
 
=head1 DESCRIPTION
 
A text annotation that can be put over a chart.  You can find an example
of an Annotation at L<http://gphat.github.com/chart-clicker/static/images/examples/annotation.png>.
 
=head1 ATTRIBUTES
 
=head2 axis_height
 
Set/Get the height of the OverAxis that will be drawn.
 
=head2 background_color
 
Set/Get the background L<color|Graphics::Color::RGB> for this Annotation.
 
=head2 color
 
Set/Get the font L<color|Graphics::Color::RGB> for this Annotation.
 
=head2 context
 
Set/Get the context that this Annotation should use.
 
=head2 key
 
Set/Get the x-axis value for the position of the Annotation.
 
=head2 layout_manager
 
The layout manager to use for this overaxis. Defaults to a L<Layout::Manager::Absolute>.

=head2 offset
 
Set/Get the L<offset|Geometry::Primitive::Point> from (key,value) for the position of the Annotation.
 
=head2 text
 
Set/Get the Annotation text.

=head2 value
 
Set/Get the y-axis value for the position of the Annotation.
 
=head1 AUTHOR
 
Cory G Watson <gphat@cpan.org>
 
=head1 COPYRIGHT AND LICENSE
 
This software is copyright (c) 2014 by Cold Hard Code, LLC.
 
This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
 
=cut    
