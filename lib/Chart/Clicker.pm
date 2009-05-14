package Chart::Clicker;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::AttributeHelpers;

extends 'Chart::Clicker::Container';

use Layout::Manager::Compass;

use Graphics::Color::RGB;

use Graphics::Primitive::Insets;
use Graphics::Primitive::Border;

use Graphics::Primitive::Driver::Cairo;

use Chart::Clicker::Context;

use Chart::Clicker::Decoration::Legend;
use Chart::Clicker::Decoration::MarkerOverlay;
use Chart::Clicker::Decoration::Plot;
use Chart::Clicker::Renderer;
use Chart::Clicker::Drawing::ColorAllocator;

use Class::MOP;

use Scalar::Util qw(refaddr);

our $VERSION = '2.31';

coerce 'Chart::Clicker::Renderer'
    => from 'Str'
    => via {
        my $class = 'Chart::Clicker::Renderer::'.$_;
        Class::MOP::load_class($class);
        return $class->new
    };

has '+background_color' => (
    default => sub {
        Graphics::Color::RGB->new(
            { red => 1, green => 1, blue => 1, alpha => 1 }
        )
    }
);
has '+border' => (
    default => sub {
        my $b = Graphics::Primitive::Border->new;
        $b->color(Graphics::Color::RGB->new(red => 0, green => 0, blue => 0));
        $b->width(1);
        return $b;
    }
);
has 'color_allocator' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::ColorAllocator',
    default => sub { Chart::Clicker::Drawing::ColorAllocator->new }
);
has 'contexts' => (
    metaclass => 'Collection::Hash',
    is => 'rw',
    isa => 'HashRef[Chart::Clicker::Context]',
    default => sub { { default => Chart::Clicker::Context->new(name => 'default') } },
    provides => {
        set    => 'set_context',
        get     => 'get_context',
        keys    => 'context_names',
        count   => 'context_count',
        delete  => 'delete_context'
    }
);
has 'datasets' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        'count'=> 'dataset_count',
        'push' => 'add_to_datasets',
        'get' => 'get_dataset'
    }
);
has 'driver' => (
    is => 'rw',
    does => 'Graphics::Primitive::Driver',
    default => sub {
        my ($self) = @_;
        Graphics::Primitive::Driver::Cairo->new(
            format => $self->format,
        )
    },
    handles => [ qw(data write) ],
    lazy => 1
);
has 'format' => (
    is => 'rw',
    isa => 'Str',
    default => sub { 'PNG' }
);
has 'grid_over' => (
    is => 'rw',
    isa => 'Bool',
    default => sub { 0 }
);
has '+height' => (
    default => 300
);
has '+layout_manager' => (
    default => sub { Layout::Manager::Compass->new }
);
has 'legend' => (
    is => 'rw',
    isa => 'Chart::Clicker::Decoration::Legend',
    default => sub {
        Chart::Clicker::Decoration::Legend->new(
            name => 'legend',
        );
    }
);
has 'legend_position' => (
    is => 'rw',
    isa => 'Str',
    default => sub { 's' }
);
has 'marker_overlay' => (
    is => 'rw',
    isa => 'Chart::Clicker::Decoration::MarkerOverlay',
    lazy => 1,
    default => sub {
        Chart::Clicker::Decoration::MarkerOverlay->new
    }
);
has 'over_decorations' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        'count'=> 'over_decoration_count',
        'push' => 'add_to_over_decorations',
        'get' => 'get_over_decoration'
    }
);
has '+padding' => (
    default => sub {
        Graphics::Primitive::Insets->new(
            top => 3, bottom => 3, right => 3, left => 3
        )
    }
);
has 'plot' => (
    is => 'rw',
    isa => 'Chart::Clicker::Decoration::Plot',
    default => sub {
        Chart::Clicker::Decoration::Plot->new
    }
);

has '+width' => (
    default => 500
);

sub BUILD {
    my ($self) = @_;

    $self->add_component($self->plot, 'c');

    if($self->legend->visible) {
        $self->add_component($self->legend, $self->legend_position);
    }
}

sub add_to_contexts {
    my ($self, $ctx) = @_;

    if(defined($self->get_context($ctx->name))) {
        croak("Context named '".$ctx->name."' already exists.");
    }
    $self->set_context($ctx->name, $ctx);
}

sub draw {
    my ($self) = @_;

    my $driver = $self->driver;
    $driver->prepare($self);

    $self->layout_manager->do_layout($self);
    $driver->finalize($self);
    $driver->draw($self);
}

sub get_datasets_for_context {
    my ($self, $name) = @_;

    my @dses;
    foreach my $ds (@{ $self->datasets }) {
        if($ds->context eq $name) {
            push(@dses, $ds);
        }
    }

    return \@dses;
}

override('prepare', sub {
    my ($self, $driver) = @_;

    return if $self->prepared;

    my $plot = $self->plot;

    $plot->clear_components;
    $plot->render_area->clear_components;

    # These two adds are here because the plot is too dependant on changes
    # in the axes and such to trust it across multiple prepares.  Putting all
    # of this here made it easier to digest, although this has some codestink
    # to it...
    if($plot->grid->visible && !$self->grid_over) {
        $plot->render_area->add_component($plot->grid, 'c');
    }

    if($plot->markers) {
        $plot->render_area->add_component(
            $self->marker_overlay
        );
    }

    # Sentinels to control the side that the axes will be drawn on.
    my $dcount = 0;
    my $rcount = 0;
    # Hashes of axes & renderers we've already seen, as we don't want to add
    # them again...
    my %xaxes;
    my %yaxes;
    my %rends;

    my $dflt_ctx = $self->get_context('default');
    die('Clicker must have a default context') unless defined($dflt_ctx);

    # Prepare the datasets and establish ranges for the axes.
    my $count = 0;
    foreach my $ds (@{ $self->datasets }) {
        unless($ds->count > 0) {
            die("Dataset $count is empty.");
        }

        $ds->prepare;

        my $ctx = $self->get_context($ds->context);

        unless(defined($ctx)) {
            $ctx = $dflt_ctx;
        }

        # Find our x axis and add it.
        my $xaxis = $ctx->domain_axis;
        unless(exists($xaxes{refaddr($xaxis)})) {
            $xaxis->range->combine($ds->domain);

            $xaxis->orientation('horizontal');

            if($dcount % 2) {
                $xaxis->position('top');
                $xaxis->border->bottom->width($xaxis->brush->width);
            } else {
                $xaxis->position('bottom');
                $xaxis->border->top->width($xaxis->brush->width);
            }
            $xaxis->border->color($xaxis->color);

            $plot->add_component($xaxis, $xaxis->is_top ? 'n' : 's');
            $xaxes{refaddr($xaxis)} = 1;
            $dcount++;
        }

        # Find our y axis and add it.
        my $yaxis = $ctx->range_axis;
        unless(exists($yaxes{refaddr($yaxis)})) {
            $yaxis->range->combine($ds->range);

            $yaxis->orientation('vertical');

            if($rcount % 2) {
                $yaxis->position('right');
                $yaxis->border->left->width($yaxis->brush->width);
            } else {
                $yaxis->position('left');
                $yaxis->border->right->width($yaxis->brush->width);
            }
            $yaxis->border->color($yaxis->color);

            $plot->add_component($yaxis, $yaxis->is_left ? 'w' : 'e');
            $rcount++;
            $yaxes{refaddr($yaxis)} = 1;
        }

        my $rend = $ctx->renderer;
        if($rend->additive) {
            $yaxis->range->upper($ds->largest_value_slice);
        } else {
            $yaxis->range->combine($ds->range);
        }
        unless(exists($rends{$ctx->name})) {
            $rend->context($ctx->name);
            $rend->clicker($self);
            $plot->render_area->add_component($rend, 'c');
        }

        $count++;
    }

    if($plot->grid->visible && $self->grid_over) {
        $plot->grid->background_color->alpha(0);
        $plot->render_area->add_component($plot->grid, 'c');
    }

    foreach my $c (@{ $self->components }) {
        $c->clicker($self);
    }

    $plot->add_component($plot->render_area, 'c');

    foreach my $oc (@{ $self->over_decorations }) {
        $plot->render_area->add_component($oc, 'c');
    }

    super;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;

__END__

=head1 NAME

Chart::Clicker - Powerful, extensible charting.

=head1 SYNOPSIS

  use Chart::Clicker
  use Chart::Clicker::Data::Series;
  use Chart::Clicker::Data::DataSet;

  my $cc = Chart::Clicker->new;

  my $series = Chart::Clicker::Data::Series->new(
    keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
    values  => [ 42, 25, 86, 23, 2, 19, 103, 12, 54, 9 ],
  );

  my $series2 = Chart::Clicker::Data::Series->new(
    keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
    values  => [ 67, 15, 6, 90, 11, 45, 83, 11, 9, 101 ],
  );

  my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series, $series2 ]);
 
  $cc->add_to_datasets($ds);

  $cc->draw;
  $cc->write('foo.png')

=head1 DESCRIPTION

Chart::Clicker aims to be a powerful, extensible charting package that creates
really pretty output.  Charts can be saved in png, svg, pdf and postscript
format.

Clicker leverages the power of Graphics::Primitive to create snazzy graphics
without being tied to specific backend.

For examples, see: L<http://www.onemogin.com/clicker/examples>

=head1 COOKBOOK

Check the cookbook at L<http://www.onemogin.com/clicker/cookbook>

=head1 UPGRADING FROM 1.0

The differences between 1.0 and 2.0 are long and onerous.  The way you create
charts has changed (see the SYNOPSIS) but the way you provide data to them
has not.

I strongly recommend reading the following section if you used advanced
features.

=head1 CONTEXTS

The normal use case for a chart is a couple of datasets on the same axes.
Sometimes you want to chart one or more datasets on different axes.  A common
need for this is when you are comparing two datasets of vastly different scale
such as the number of employees in an office (1-10) to monthly revenues (10s
of thousands).  On a normal chart the number of employees would show up as a
flat line at the bottom of the chart.

To correct this, Clicker has contexts.  A context is a pair of axes, a
renderer and a name.  The name is the 'key' by which you will refer to the
context.

  my $context = Chart::Clicker::Context->new( name => 'sales' );
  $clicker->add_to_contexts($context);
  
  $dataset->context('sales');
  
  $clicker->add_to_datasets($dataset);
  
New contexts provide a fresh domain and range axis and default to a Line
renderer. 

B<Caveat>: Clicker expects that the default context (identified by the string
"default") will always be present.  It is from this context that some of
Clicker's internals draw their values.  You should use the default context
unless you need more than one, in which case you should use "default" as the
base context.

=head1 FORMATS

Clicker supports PNG, SVG, PDF and PostScript output.

=head1 METHODS

=head2 new

Creates a new Chart::Clicker object. If no format, width and height are
specified then defaults of Png, 500 and 300 are chosen, respectively.

=head2 add_to_contexts

Add the specified context to the chart.

=head2 add_to_datasets

Add the specified dataset (or arrayref of datasets) to the chart.

=head2 add_to_markers

Add the specified marker to the chart.

=head2 color_allocator

Set/Get the color_allocator for this chart.

=head2 context

Set/Get the context for this chart.

=head2 data

Returns the data for this chart as a scalar.  Suitable for 'streaming' to a
client.

=head2 datasets

Get/Set the datasets for this chart.

=head2 draw

Draw this chart.

=head2 format

Get the format for this Chart.  Required in the constructor.  Must be on of
Png, Pdf, Ps or Svg.

=head2 get_datasets_for_context

Returns an arrayref containing all datasets for the given context.  Used by
renderers to get a list of datasets to chart.

=head2 grid_over

Flag controlling if the grid is rendered B<over> the data.  Defaults to 0.
You probably want to set the grid's background color to an alpha of 0 if you
enable this flag.

=head2 inside_width

Get the width available in this container after taking away space for
insets and borders.

=head2 inside_height

Get the height available in this container after taking away space for
insets and borders.

=head2 legend

Set/Get the legend that will be used with this chart.

=head2 legend_position

The position this legend will be added.  Should be one of north, south, east,
west or center as required by L<Layout::Manager::Compass>.

=head2 marker_overlay

Set/Get the marker overlay object that will be used if this chart
has markers.  This is lazily constructed to save time.

=head2 write

Write the chart output to the specified location. Output is written in the
format provided to the constructor (which defaults to Png).

  $c->write('/path/to/the.png');

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 CONTRIBUTORS

Many thanks to the individuals who have contributed various bits:

Ash Berlin
Brian Cassidy
Guillermo Roditi
Torsten Schoenfeld
Yuval Kogman

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
