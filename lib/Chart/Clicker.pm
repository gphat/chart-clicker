package Chart::Clicker;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::AttributeHelpers;

extends 'Chart::Clicker::Container';

use Carp;

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

our $VERSION = '1.99_11';

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
            format => $self->format
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
has '+padding' => (
    default => sub {
        Graphics::Primitive::Insets->new( top => 5, bottom => 5, right => 5, left => 5)
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
    $driver->pack($self);
    $driver->draw($self);
}

sub BUILD {
    my ($self) = @_;

    $self->add_component($self->plot, 'c');

    if($self->legend->visible) {
        $self->add_component($self->legend, $self->legend_position);
    }
}

override('prepare', sub {
    my ($self, $driver) = @_;

    return if $self->prepared;

    my $plot = $self->plot;

    $plot->clear_components;
    $self->plot->render_area->clear_components;

    # These two adds are here because the plot is too dependant on changes
    # in the axes and such to trust it across multiple prepares.  Putting all
    # of this here made it easier to digest, although this has some codestink
    # to it...
    if($plot->grid->visible) {
        $plot->render_area->add_component($plot->grid, 'c');
    }

    if($plot->markers) {
        $plot->render_area->add_component(
            Chart::Clicker::Decoration::MarkerOverlay->new
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
                $xaxis->border->bottom->width(1);
                $xaxis->border->bottom->color($xaxis->color);
                $xaxis->position('top');
            } else {
                $xaxis->border->top->width(1);
                $xaxis->border->top->color($xaxis->color);
                $xaxis->position('bottom');
            }

            $xaxis->padding->bottom(5);
            $xaxis->padding->top(5);

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
                $yaxis->border->left->width(1);
                $yaxis->border->left->color($xaxis->color);
            } else {
                $yaxis->position('left');
                $yaxis->border->right->width(1);
                $yaxis->border->right->color($xaxis->color);
            }
            $yaxis->padding->left(5);
            $yaxis->padding->right(5);

            $plot->add_component($yaxis, $yaxis->is_left ? 'w' : 'e');
            $rcount++;
            $yaxes{refaddr($yaxis)} = 1;
        }

        my $rend = $ctx->renderer;
        if($rend->additive) {
            $yaxis->range->upper($ds->largest_value_slice - 5);
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

    foreach my $c (@{ $self->components }) {
        $c->clicker($self);
    }

    super;
});

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

At it's core Clicker is more of a toolkit for creating charts.  It's interface
is a bit more complex because making pretty charts requires attention and care.
Some fine defaults are established to make getting started easier, but to really
unleash the potential of Clicker you must roll up your sleeves and build
things by hand.

=head1 WARNING

Clicker has aspirations to do more and be better.  Good software is not Athena
and therefore doesn't spring fully formed from the mind.  It is entirely
possible that new features will be added that may change behavior. You can
find more information at L<http://www.onemogin.com/clicker>.  Feel free to
send your criticisms, advice, patches or money to me as a way of helping.

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

=head1 FORMATS

Clicker supports PNG, SVG, PDF and PostScript output.

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Chart::Clicker object. If no format, width and height are
specified then defaults of Png, 500 and 300 are chosen, respectively.

=back

=head2 Instance Methods

=over 4

=item I<add_to_contexts>

Add the specified context to the chart.

=item I<add_to_datasets>

Add the specified dataset (or arrayref of datasets) to the chart.

=item I<add_to_markers>

Add the specified marker to the chart.

=item I<color_allocator>

Set/Get the color_allocator for this chart.

=item I<context>

Set/Get the context for this chart.

=item I<data>

Returns the data for this chart as a scalar.  Suitable for 'streaming' to a
client.

=item I<datasets>

Get/Set the datasets for this chart.

=item I<draw>

Draw this chart.

=item I<format>

Get the format for this Chart.  Required in the constructor.  Must be on of
Png, Pdf, Ps or Svg.

=item I<get_datasets_for_context>

Returns an arrayref containing all datasets for the given context.  Used by
renderers to get a list of datasets to chart.

=item I<inside_width>

Get the width available in this container after taking away space for
insets and borders.

=item I<inside_height>

Get the height available in this container after taking away space for
insets and borders.

=item I<legend>

Set/Get the legend that will be used with this chart.

=item I<legend_position>

The position this legend will be added.  Should be one of north, south, east,
west or center as required by L<Layout::Manager::Compass>.

=item I<write>

Write the chart output to the specified location. Output is written in the
format provided to the constructor (which defaults to Png).

  $c->write('/path/to/the.png');

=item I<BUILD>

Documenting so tests pass.  Moose stuff.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 CONTRIBUTORS

Torsten Schoenfeld
Ash Berlin

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
