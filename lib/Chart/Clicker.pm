package Chart::Clicker;
use Moose;

extends 'Chart::Clicker::Container';

# ABSTRACT: Powerful, extensible charting.

use Layout::Manager::Compass;

use Graphics::Color::RGB;

use Graphics::Primitive::Insets;
use Graphics::Primitive::Border;

#use Graphics::Primitive::Driver::Cairo;

use Chart::Clicker::Context;

use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Decoration::Legend;
use Chart::Clicker::Decoration::MarkerOverlay;
use Chart::Clicker::Decoration::Plot;
use Chart::Clicker::Drawing::ColorAllocator;

use Carp qw(croak);
use Scalar::Util qw(refaddr);

=head1 SYNOPSIS

  use Chart::Clicker;

  my $cc = Chart::Clicker->new;

  my @values = (42, 25, 86, 23, 2, 19, 103, 12, 54, 9);
  $cc->add_data('Sales', \@values);

  # alternately, you can add data one bit at a time...
  foreach my $v (@values) {
    $cc->add_data('Sales', $v);
  }

  # Or, if you want to specify the keys you can use a hashref
  my $data = { 12 => 123, 13 => 341, 14 => 1241 };
  $cc->add_data('Sales', $data);

  $cc->write_output('foo.png');

=head1 DESCRIPTION

Chart::Clicker aims to be a powerful, extensible charting package that creates
really pretty output.  Charts can be saved in png, svg, pdf and postscript
format.

Clicker leverages the power of Graphics::Primitive to create snazzy graphics
without being tied to specific backend.  You may want to begin with
L<Chart::Clicker::Tutorial>.

=begin :prelude

=head1 EXAMPLES

For code examples see the examples repository on GitHub:
L<http://github.com/gphat/chart-clicker-examples/>

=head1 FEATURES

=head2 Renderers

Clicker supports the following renderers:

=over 4

=item B<Line>

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/line.png" width="500" height="250" alt="Line Chart" /></p>

=end HTML

=item B<StackedLine>

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/stacked-line.png" width="500" height="250" alt="Stacked Line Chart" /></p>

=end HTML

=item B<Bar>

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/bar.png" width="500" height="250" alt="Bar Chart" /></p>

=end HTML

=item B<StackedBar>

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/stacked-bar.png" width="500" height="250" alt="Stacked Bar Chart" /></p>

=end HTML

=item B<Area>

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/area.png" width="500" height="250" alt="Area Chart" /></p>

=end HTML

=item B<StackedArea>

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/stacked-area.png" width="500" height="250" alt="Stacked Area Chart" /></p>

=end HTML

=item B<Bubble>

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/bubble.png" width="500" height="250" alt="Bubble Chart" /></p>

=end HTML

=item B<CandleStick>

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/candlestick.png" width="500" height="250" alt="Candlestick Chart" /></p>

=end HTML

=item B<Point>

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/point.png" width="500" height="250" alt="Point Chart" /></p>

=end HTML

=item B<Pie>

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/pie.png" width="300" height="250" alt="Pie Chart" /></p>

=end HTML

=item B<PolarArea>

=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/polararea.png" width="300" height="250" alt="Polar Area Chart" /></p>

=end HTML


=back

=head1 ADDING DATA

The synopsis shows the simple way to add data.

  my @values = (42, 25, 86, 23, 2, 19, 103, 12, 54, 9);
  foreach my $v (@values) {
    $cc->add_data('Sales', $v);
  }

This is a convenience method provided to make simple cases much simpler. Adding
multiple Series to a chart is as easy as changing the name argument of
C<add_data>.  Each unique first argument will result in a separate series. See
the docs for C<add_data> to learn more.

If you'd like to use the more advanced features of Clicker you'll need to
shake off this simple method and build Series & DataSets explicitly.

  use Chart::Clicker::Data::Series;
  use Chart::Clicker::Data::DataSet;

  ...

  my $series = Chart::Clicker::Data::Series->new(
    keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
    values  => [ 42, 25, 86, 23, 2, 19, 103, 12, 54, 9 ],
  );

  my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series ]);

  $cc->add_to_datasets($ds);

This used to be the only way to add data, but repeated requests to make the
common case easier resulted in the inclusion of C<add_data>.

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

=head1 FORMATS & OUTPUT

Clicker supports PNG, SVG, PDF and PostScript output.  To change your output
type, specificy it when you create your Clicker object:

  my $cc = Chart::Clicker->new(format => 'pdf', ...);
  # ...
  $cc->write_output('chart.pdf');

If you are looking to get a scalar of the output for use with HTTP or
similar things, you can use:

  # ... make your chart
  $cc->draw;
  my $image_data = $cc->rendered_data;

If you happen to be using Catalyst then take a look at
L<Catalyst::View::Graphics::Primitive>.

=end :prelude

=attr background_color

Set/Get the background L<color|Graphics::Color::RGB>. Defaults to white.

=cut

has '+background_color' => (
    default => sub {
        Graphics::Color::RGB->new({ red => 1, green => 1, blue => 1, alpha => 1 })
    }
);

=attr border

Set/Get the L<border|Graphics::Primitive::Border>.

=cut

has '+border' => (
    default => sub {
        my $b = Graphics::Primitive::Border->new;
        $b->color(Graphics::Color::RGB->new(red => 0, green => 0, blue => 0));
        $b->width(1);
        return $b;
    }
);

=attr color_allocator

Set/Get the L<color_allocator|Chart::Clicker::Drawing::ColorAllocator> for this chart.

=cut

has 'color_allocator' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::ColorAllocator',
    default => sub { Chart::Clicker::Drawing::ColorAllocator->new }
);

=attr contexts

Set/Get the L<contexts|Chart::Clicker::Context> for this chart.

=method context_count

Get a count of contexts.

=method context_names

Get a list of context names.

=method delete_context ($name)

Remove the context with the specified name.

=method get_context ($name)

Get the context with the specified name

=method set_context ($name, $context)

Set a context of the specified name.

=cut

has 'contexts' => (
    traits => [ 'Hash' ],
    is => 'rw',
    isa => 'HashRef[Chart::Clicker::Context]',
    default => sub { { default => Chart::Clicker::Context->new(name => 'default') } },
    handles => {
        'set_context' => 'set',
        'get_context' => 'get',
        'context_names' => 'keys',
        'context_count' => 'count',
        'delete_context' => 'delete'
    }
);

has '_data' => (
    traits => [ 'Hash' ],
    is => 'rw',
    isa => 'HashRef[Str]',
    default => sub { {} }
);

=attr datasets

Get/Set the datasets for this chart.

=method add_to_datasets

Add the specified dataset (or arrayref of datasets) to the chart.

=method dataset_count

Get a count of datasets.

=method get_dataset ($index)

Get the dataset at the specified index.

=cut

has 'datasets' => (
    traits => [ 'Array' ],
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    handles => {
        'dataset_count' => 'count',
        'add_to_datasets' => 'push',
        'get_dataset' => 'get'
    }
);

=attr driver

Set/Get the L<driver|Graphics::Primitive::Driver> used to render this Chart. Defaults to
L<Graphics::Primitive::Driver::Cairo>.

=method rendered_data

Returns the data for this chart as a scalar.  Suitable for 'streaming' to a
client.

=cut

has 'driver' => (
    is => 'rw',
    does => 'Graphics::Primitive::Driver',
    default => sub {
        my ($self) = @_;
        my $driver = $ENV{CHART_CLICKER_DEFAULT_DRIVER} || ($^O eq 'MSWin32'?"Graphics::Primitive::Driver::GD":"Graphics::Primitive::Driver::Cairo");
        eval "require $driver;" or die "Cannot load driver $driver";
        $driver->new(
            'format' => $self->format,
        )
    },
    handles => {
        rendered_data => 'data',
        write => 'write'
    },
    lazy => 1
);

=attr format

Get the format for this Chart.  Required in the constructor.  Must be on of
Png, Pdf, Ps or Svg.

=cut

has 'format' => (
    is => 'rw',
    isa => 'Str',
    default => 'PNG'
);

=attr plot_mode

Fast or slow plot mode. When in fast mode, data elements that are deemed to be
superfluous or invisible will not be drawn. Default is 'slow'

=cut

has 'plot_mode' => (
    is => 'rw',
    isa => 'Str',
    default => 'slow'
);

=attr grid_over

Flag controlling if the grid is rendered B<over> the data.  Defaults to 0.
You probably want to set the grid's background color to an alpha of 0 if you
enable this flag.

=cut

has 'grid_over' => (
    is => 'rw',
    isa => 'Bool',
    default => 0
);

=attr height

Set/Get the height.  Defaults to 300.

=cut

has '+height' => (
    default => 300
);

=attr layout_manager

Set/Get the layout manager.  Defaults to L<Layout::Manager::Compass>.

=cut

has '+layout_manager' => (
    default => sub { Layout::Manager::Compass->new }
);

=attr legend

Set/Get the L<legend|Chart::Clicker::Decoration::Legend> that will be used with this chart.

=cut

has 'legend' => (
    is => 'rw',
    isa => 'Chart::Clicker::Decoration::Legend',
    default => sub {
        Chart::Clicker::Decoration::Legend->new(
            name => 'legend',
        );
    }
);

=attr legend_position

The position the legend will be added.  Should be one of north, south, east,
west or center as required by L<Layout::Manager::Compass>.

=cut

has 'legend_position' => (
    is => 'rw',
    isa => 'Str',
    default => 's'
);

=attr marker_overlay

Set/Get the L<marker overlay|Chart::Clicker::Decoration::MarkerOverlay> object that will be used if this chart
has markers.  This is lazily constructed to save time.

=cut

has 'marker_overlay' => (
    is => 'rw',
    isa => 'Chart::Clicker::Decoration::MarkerOverlay',
    lazy => 1,
    default => sub {
        Chart::Clicker::Decoration::MarkerOverlay->new
    }
);

=attr over_decorations

Set/Get an arrayref of "over decorations", or things that are drawn OVER the
chart.  This is an advanced feature.  See C<overaxis-bar.pl> in the examples.

=method add_to_over_decorations

Add an over decoration to the list.

=method get_over_decoration ($index)

Get the over decoration at the specified index.

=method over_decoration_count

Get a count of over decorations.

=cut

has 'over_decorations' => (
    traits => [ 'Array' ],
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    handles => {
        'over_decoration_count' => 'count',
        'add_to_over_decorations' => 'push',
        'get_over_decoration' => 'get'
    }
);

=attr padding

Set/Get the L<padding|Graphics::Primitive::Insets>. Defaults
to 3px on all sides.

=cut

has '+padding' => (
    default => sub {
        Graphics::Primitive::Insets->new(
            top => 3, bottom => 3, right => 3, left => 3
        )
    }
);

=attr plot

Set/Get the L<plot|Chart::Clicker::Decoration::Plot> on which things are drawn.

=cut

has 'plot' => (
    is => 'rw',
    isa => 'Chart::Clicker::Decoration::Plot',
    default => sub {
        Chart::Clicker::Decoration::Plot->new
    }
);

=attr subgraphs

You can add "child" graphs to this one via C<add_subgraph>.  These must be
Chart::Clicker objects and they will be added to the bottom of the existing
chart.  This is a rather esoteric feature.

=cut

has 'subgraphs' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    predicate => 'has_subgraphs'
);

=attr title

Set/Get the title component for this chart.  This is a
L<Graphics::Primitive::TextBox>, not a string.  To set the title of a chart
you should access the TextBox's C<text> method.

  $cc->title->text('A Title!');
  $cc->title->font->size(20);
  # etc, etc

If the title has text then it is added to the chart in the position specified
by C<title_position>.

You should consult the documentation for L<Graphics::Primitive::TextBox> for
things like padding and text rotation.  If you are adding it to the top and
want some padding between it and the plot, you can:

  $cc->title->padding->bottom(5);

=cut

has 'title' => (
    is => 'rw',
    isa => 'Graphics::Primitive::TextBox',
    default => sub {
        Graphics::Primitive::TextBox->new(
            color => Graphics::Color::RGB->new( red => 0, green => 0, blue => 0),
            horizontal_alignment => 'center'
        )
    }
);

=attr title_position

The position the title will be added.  Should be one of north, south, east,
west or center as required by L<Layout::Manager::Compass>.

Note that if no angle is set for the title then it will be changed to
-1.5707 if the title position is east or west.

=cut

has 'title_position' => (
    is => 'rw',
    isa => 'Str',
    default => 'n'
);

=attr width

Set/Get the width.  Defaults to 500.

=cut

has '+width' => (
    default => 500
);

=method add_to_contexts

Add the specified context to the chart.

=cut

sub add_to_contexts {
    my ($self, $ctx) = @_;

    if(defined($self->get_context($ctx->name))) {
        croak("Context named '".$ctx->name."' already exists.");
    }
    $self->set_context($ctx->name, $ctx);
}

=method add_subgraph

Add a subgraph to this chart.

=cut

sub add_subgraph {
    my ($self, $graph) = @_;

    if (not ref $graph or not $graph->isa('Chart::Clicker')) {
        die('Sub-Graphs must be Chart::Clicker objects');
    }
    push(@{$self->subgraphs}, $graph);
}

sub data {
    my ($self) = @_;
    print STDERR "WARNING: Calling 'data' to get image data is deprecated, please use rendered_data\n";
    $self->rendered_data;
}

=method draw

Draw this chart.

=cut

sub draw {
    my ($self) = @_;
    my $driver = $self->driver;
    $driver->prepare($self);

    $self->layout_manager->do_layout($self);
    $driver->finalize($self);
    $driver->draw($self);
}

=method get_datasets_for_context

Returns an arrayref containing all datasets for the given context.  Used by
renderers to get a list of datasets to chart.

=cut

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

=method add_data ($name, $data)

Convenience method for adding data to the chart.  Can be called one of three
ways.

=over 4

=item B<scalar>

Passing a name and a scalar will append the scalar data to that series' data.

  $cc->add_data('Sales', 1234);
  $cc->add_data('Sales', 1235);

This will result in a Series named 'Sales' with two values.

=item B<arrayref>

Passing a name and an arrayref works much the same as the scalar method
discussed above, but appends the supplied arrayref to the existing one.  It
may be mixed with the scalar method.

  $cc->add_data('Sales', \@some_sales);
  $cc->add_data('Sales', \@some_more_sales);
  # This works still!
  $cc->add_data('Sales', 1234);

=item B<hashref>

This allows you to pass both keys and values in all at once.

  $cc->add_data('Sales', { 2009 => 1234, 2010 => 1235 });
  # appends to last call
  $cc->add_data('Sales', { 2011 => 1234, 2012 => 1235 });

You may call the hashref version after the scalar or arrayref versions, but you
may not add a scalar or arrayref after adding a hashref (as it's not clear what
indices should be used for the new data).

=back

=cut

sub add_data {
    my ($self, $name, $data) = @_;

    if(ref($data) eq 'ARRAY') {
        croak "Can't add arrayref data after adding hashrefs"
            if ref($self->_data->{$name}) eq 'HASH';
        $self->_data->{$name} = [] unless defined($self->_data->{$name});
        push(@{ $self->_data->{$name}}, @{ $data });
    } elsif(ref($data) eq 'HASH') {
        if (!defined $self->_data->{$name}) {
            $self->_data->{$name} = {};
        } elsif (ref($self->_data->{$name}) eq 'ARRAY') {
            my $old_data = $self->_data->{$name};
            $self->_data->{$name} = {};
            for my $i (0 .. @$old_data - 1) {
                $self->_data->{$name}{$i} = $old_data->[$i];
            }
        }
        for my $key (keys %$data) {
            $self->_data->{$name}{$key} = $data->{$key};
        }
    } else {
        croak "Can't add scalar data after adding hashrefs"
            if ref($self->_data->{$name}) eq 'HASH';
        $self->_data->{$name} = [] unless defined($self->_data->{$name});
        push(@{ $self->_data->{$name}}, $data);
    }
}

override('prepare', sub {
    my ($self, $driver) = @_;

    return if $self->prepared;

    if(scalar(keys(%{ $self->_data }))) {

        my $ds = Chart::Clicker::Data::DataSet->new;
        foreach my $name (keys(%{ $self->_data })) {

            my $vals = $self->_data->{$name};

            if(ref($vals) eq 'ARRAY') {
                # This allows the user to add data as an array

                $ds->add_to_series(
                    Chart::Clicker::Data::Series->new(
                        name    => $name,
                        keys    => [ 0..scalar(@{ $vals }) - 1 ],
                        values  => $vals
                    )
                );
            } elsif(ref($vals) eq 'HASH') {
                # This allows the user to add data as a hashref
                my @keys = sort { $a <=> $b } keys %{ $vals };

                my @values = ();
                foreach my $k (@keys) {
                    push(@values, $vals->{$k})
                }

                $ds->add_to_series(
                    Chart::Clicker::Data::Series->new(
                        name => $name,
                        keys => \@keys,
                        values => \@values
                    )
                );
            }
        }
        $self->add_to_datasets($ds);
    }

    unless(scalar(@{ $self->components })) {
        $self->add_component($self->plot, 'c');

        my $lp = lc($self->legend_position);
        if($self->legend->visible) {
            if(($lp =~ /^e/) || ($lp =~ /^w/)) {
                $self->legend->orientation('vertical');
            }
            $self->add_component($self->legend, $self->legend_position);
        }

        # Add subgraphs
        if($self->has_subgraphs) {
            for my $subgraph (@{$self->subgraphs}) {
                $subgraph->border->width(0);
                $subgraph->padding(0);

                $self->add_component($subgraph, 'south');
            }
        }

        if(defined($self->title->text)) {
            my $tp = $self->title_position;
            if(($tp =~ /^e/) || ($tp =~ /^w/)) {
                unless(defined($self->title->angle)) {
                    $self->title->angle(-1.5707);
                }
            }
            $self->add_component($self->title, $tp);
        }
    }

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

    $plot->render_area->add_component(
        $self->marker_overlay
    );

    # Sentinels to control the side that the axes will be drawn on.
    my $dcount = 0;
    my $rcount = 0;
    # Hashes of axes & renderers we've already seen, as we don't want to add
    # them again...
    my %xaxes;
    my %yaxes;

    # A "seen" hash to prevent us from adding multiple renderers for the same
    # context.
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

        # Only add this renderer to the chart if we haven't seen it already.
        unless(exists($rends{$ctx->name})) {
            $rend->context($ctx->name);
            $rend->clicker($self);
            $plot->render_area->add_component($rend, 'c');
            $rends{$ctx->name} = $rend;
        }

        $count++;
    }

    if($plot->grid->visible && $self->grid_over) {
        $plot->grid->background_color->alpha(0);
        $plot->render_area->add_component($plot->grid, 'c');
    }

    foreach my $c (@{ $self->components }) {
        $c->clicker($self) if $c->can('clicker');
    }

    $plot->add_component($plot->render_area, 'c');

    foreach my $oc (@{ $self->over_decorations }) {
        $plot->render_area->add_component($oc, 'c');
    }

    super;
});

=method set_renderer ($renderer_object, [ $context ]);

Sets the renderer on the specified context.  If no context is provided then
'default' is assumed.

=cut

sub set_renderer {
    my ($self, $renderer, $context) = @_;

    $context = 'default' unless defined($context);

    my $ctx = $self->get_context($context);
    die("Unknown context: '$context'") unless defined($ctx);

    $ctx->renderer($renderer);
}

=method write

This method is passed through to the underlying driver.  It is only necessary
that you call this if you manually called C<draw> beforehand.  You likely
want to use C<write_output>.

=method write_output ($path)

Write the chart output to the specified location. Output is written in the
format provided to the constructor (which defaults to Png).  Internally
calls C<draw> for you.  If you use this method, do not call C<draw> first!

  $c->write_output('/path/to/the.png');

=cut

sub write_output {
    my $self = shift;

    $self->draw;
    $self->write(@_);
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;

=method inside_width

Get the width available in this container after taking away space for
insets and borders.

=method inside_height

Get the height available in this container after taking away space for
insets and borders.

=begin :postlude

=head1 ISSUES WITH CENTOS

I've had numerous reports of problems with Chart::Clicker when using CentOS.
This problem has usually be solved by updating the version of cairo.  I've
had reports that upgrading to at least cairo-1.8.8-3 makes thinks work properly.

I hesitate to provide any other data with this because it may get out of date
fast.  If you have trouble feel free to drop me an email and I'll tell you
what I know.

=head1 CONTRIBUTORS

Many thanks to the individuals who have contributed various bits:

Ash Berlin

Brian Cassidy

Guillermo Roditi

Torsten Schoenfeld

Yuval Kogman

=head1 SOURCE

Chart::Clicker is on github:

  http://github.com/gphat/chart-clicker/tree/master

=end :postlude

=cut
