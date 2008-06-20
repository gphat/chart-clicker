package Chart::Clicker;
use Moose;
use Moose::Util::TypeConstraints;

extends 'Chart::Clicker::Drawing::Container';

use Chart::Clicker::Decoration::Plot;
use Chart::Clicker::Format::Png;
use Chart::Clicker::Util;

subtype 'Format'
    => as 'Object'
    => where { $_->does('Chart::Clicker::Format') };

coerce 'Format'
    => from 'Str'
    => via {
        return Chart::Clicker::Util::load('Chart::Clicker::Format::'.$_)
    };

has 'format' => (
    is      => 'rw',
    isa     => 'Format',
    coerce  => 1,
    default => sub { return Chart::Clicker::Format::Png->new() }
);

has 'color_allocator' => (
    is => 'rw',
    isa => 'Chart::Clicker::Drawing::ColorAllocator',
    default => sub { new Chart::Clicker::Drawing::ColorAllocator()  }
);

has 'context' => (
    is => 'rw',
    isa => 'Chart::Clicker::Context',
);

has 'datasets' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] }
);

has 'domain_axes' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] }
);

has 'markers' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] }
);

has 'plot' => (
    is => 'rw',
    isa => 'Chart::Clicker::Decoration::Plot',
    default => sub {
        new Chart::Clicker::Decoration::Plot()
    }
);

has 'range_axes' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] }
);

has 'dataset_domain_axes' => (
    is => 'rw',
    isa => 'HashRef',
    default => sub { return {} }
);

has 'dataset_range_axes' => (
    is => 'rw',
    isa => 'HashRef',
    default => sub { return {} }
);

has 'renderer_domain_axes' => (
    is => 'rw',
    isa => 'HashRef',
    default => sub { return {} }
);

has 'renderer_range_axes' => (
    is => 'rw',
    isa => 'HashRef',
    default => sub { return {} }
);

has '+width' => (
    default => 500
);

has '+height' => (
    default => 300
);

has '+insets' => (
    default => sub {
        new Chart::Clicker::Drawing::Insets(
            { top => 5, bottom => 5, left => 5, right => 5 }
        )
    }
);

has '+border' => (
    default => sub {
        new Chart::Clicker::Drawing::Border()
    }
);

has '+background_color' => (
    default => sub {
        new Chart::Clicker::Drawing::Color(
            { red => 1, green => 1, blue => 1, alpha => 1 }
        )
    }
);

use Chart::Clicker::Drawing qw(:positions);
use Chart::Clicker::Drawing::Border;
use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::ColorAllocator;
use Chart::Clicker::Drawing::Insets;
use Chart::Clicker::Drawing::Point;

use Cairo;

our $VERSION = '1.5.0';

sub add_to_markers {
    my $self = shift();
    my $marker = shift();

    push(@{ $self->markers() }, $marker);
}

sub add_to_datasets {
    my $self = shift();
    my $ds = shift();

    push(@{ $self->datasets() }, $ds);
}

sub inside_width {
    my $self = shift();

    my $w = $self->width();

    if(defined($self->insets())) {
        $w -= $self->insets->left() + $self->insets->right()
    }
    if(defined($self->border())) {
        $w -= $self->border->stroke->width() * 2;
    }

    return $w;
}

sub inside_height {
    my $self = shift();

    my $h = $self->height();
    if(defined($self->insets())) {
        $h -= $self->insets->bottom() + $self->insets->top();
    }
    if(defined($self->border())) {
        $h -= $self->border->stroke->width() * 2;
    }

    return $h;
}

sub draw {
    my $self = shift();

    $self->SUPER::draw($self);
}

sub prepare {
    my $self = shift();

    my $plot = $self->plot();

    # Prepare the datasets and establish ranges for the axes.
    my $count = 0;
    foreach my $ds (@{ $self->datasets() }) {
        unless($ds->count() > 0) {
            die("Dataset $count is empty.");
        }

        my $rend = $plot->renderers->[$plot->get_renderer_for_dataset($count)];
        if(!defined($rend)) {
            die("Can't find a renderer, that's fatal!");
        }
        $ds->prepare();

        my $daxis = $self->get_dataset_domain_axis($count);
        if(defined($daxis)) {
            $daxis->range->combine($ds->domain());
        }

        my $raxis = $self->get_dataset_range_axis($count);

        if(defined($raxis)) {
            if($rend->additive()) {
                $raxis->range->combine($ds->combined_range());
            } else {
                $raxis->range->combine($ds->range());
            }
        }

        $count++;
    }

    $self->format->surface(
        $self->format->create_surface($self->width, $self->height)
    );
    $self->context(Chart::Clicker::Context->create($self->format->surface()));

    $self->SUPER::prepare($self, $self->dimensions());
    return 1;
}

sub set_dataset_domain_axis {
    my $self = shift();
    my $dsidx = shift();
    my $axis = shift();

    $self->dataset_domain_axes->{$dsidx} = $axis;
    return 1;
}

sub get_dataset_domain_axis {
    my $self = shift();
    my $idx = shift();

    unless(defined($self->domain_axes())) {
        return;
    }

    my $aidx = $self->dataset_domain_axes->{$idx};
    if(defined($aidx)) {
        return $self->domain_axes->[$aidx];
    } else {
        return $self->domain_axes->[0];
    }
}

sub set_dataset_range_axis {
    my $self = shift();
    my $dsidx = shift();
    my $axisidx = shift();

    $self->dataset_range_axes->{$dsidx} = $axisidx;
    return 1;
}

sub get_dataset_range_axis {
    my $self = shift();
    my $idx = shift();

    unless(defined($self->range_axes())) {
        return;
    }

    my $aidx = $self->dataset_range_axes->{$idx};
    if(defined($aidx)) {
        return $self->range_axes->[$aidx];
    } else {
        return $self->range_axes->[0];
    }
}

sub set_marker_domain_axis {
    my $self = shift();
    my $midx = shift();
    my $axis = shift();

    $self->renderer_domain_axis->{$midx} = $axis;
    return 1;
}

sub get_marker_domain_axis {
    my $self = shift();
    my $idx = shift();

    unless(defined($self->markers())) {
        return;
    }

    my $aidx = $self->renderer_domain_axes->{$idx};
    if(defined($aidx)) {
        return $self->domain_axes->[$aidx];
    } else {
        return $self->domain_axes->[0];
    }
}

sub set_marker_range_axis {
    my $self = shift();
    my $midx = shift();
    my $axisidx = shift();

    $self->renderer_range_axes->{$midx} = $axisidx;
    return 1;
}

sub get_marker_range_axis {
    my $self = shift();
    my $idx = shift();

    unless(defined($self->markers())) {
        return;
    }

    my $aidx = $self->renderer_range_axes->{$idx};
    if(defined($aidx)) {
        return $self->range_axes->[$aidx];
    } else {
        return $self->range_axes->[0];
    }
}

sub write {
    my $self = shift();
    my $file = shift();

    return $self->format->write($self, $file);
}

sub data {
    my $self = shift();

    return $self->format->data();
}

1;

__END__

=head1 NAME

Chart::Clicker - Powerful, extensible charting.

=head1 DESCRIPTION

Chart::Clicker aims to be a powerful, extensible charting package that creates
really pretty output.

Clicker leverages the power of Cairo to create snazzy 2D graphics easily and
quickly.

At it's core Clicker is more of a toolkit for creating charts.  It's interface
is a bit more complex because making pretty charts requires attention and care.
Some fine defaults are established to make getting started easier, but to really
unleash the potential of Clicker you must roll up your sleeves and build
things by hand.

The API is a bit intimidating, so it is recommended that you begin with
L<Chart::Clicker::Simple>.

=head1 WARNING

Clicker has aspirations to do more and be better.  Good software is not Athena
and therefore doesn't spring fully formed from the mind.  It is entirely
possible that new features will be added that may change behavior. You can
find more information at L<http://www.onemogin.com/clicker>.  Feel free to
send your criticisms, advice, patches or money to me as a way of helping.

=head1 FORMATS

Clicker supports PNG and SVG output.

=head1 SYNOPSIS

  use Chart::Clicker;
  use Chart::Clicker::Axis;
  use Chart::Clicker::Data::DataSet;
  use Chart::Clicker::Data::Series;
  use Chart::Clicker::Decoration::Grid;
  use Chart::Clicker::Decoration::Legend;
  use Chart::Clicker::Decoration::Plot;
  use Chart::Clicker::Drawing qw(:positions);
  use Chart::Clicker::Drawing::Insets;
  use Chart::Clicker::Renderer::Area;

  my $chart = new Chart::Clicker({ format => 'png', width => 500, height => 350 });

  my $series = new Chart::Clicker::Data::Series({
    keys    => [1, 2, 3, 4, 5, 6],
    values  => [12, 9, 8, 3, 5, 1]
  });

  my $dataset = new Chart::Clicker::Data::DataSet({
    series => [ $series ]
  });
  $chart->datasets([ $dataset ]);

  my $legend = new Chart::Clicker::Decoration::Legend({
    margins => new Chart::Clicker::Drawing::Insets({
        top => 3
    })
  });
  $chart->add($legend, $CC_BOTTOM);

  my $daxis = new Chart::Clicker::Axis({
    orientation => $CC_HORIZONTAL,
    position    => $CC_BOTTOM,
    format      => '%0.2f'
  });
  $chart->add($daxis, $CC_AXIS_BOTTOM);

  my $raxis = new Chart::Clicker::Axis({
    orientation => $CC_VERTICAL,
    position    => $CC_LEFT,
    format      => '%0.2f'
  });
  $chart->add($raxis, $CC_AXIS_LEFT);

  $chart->range_axes([ $raxis ]);
  $chart->domain_axes([ $daxis ]);

  my $grid = new Chart::Clicker::Decoration::Grid();
  $chart->add($grid, $CC_CENTER, 0);

  my $renderer = new Chart::Clicker::Renderer::Area();
  $renderer->options({
    fade => 1
  });

  my $plot = new Chart::Clicker::Decoration::Plot();
  $plot->renderers([$renderer]);
  $chart->plot($plot);

  $chart->add($plot, $CC_CENTER);

  $chart->prepare();
  $chart->draw();
  $chart->write('/path/to/chart.png');

=cut

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Chart::Clicker object. If no format, width and height are
specified then defaults of png, 500 and 300 are chosen, respectively.

=back

=head2 Class Methods

=over 4

=item inside_width

Get the width available in this container after taking away space for
insets and borders.

=item inside_height

Get the height available in this container after taking away space for
insets and borders.

=item draw

Draw this chart

=item add_to_markers

Add the specified marker to the chart.

=item add_to_datasets

Add the specified dataset (or array or datasets) to the chart.

=item prepare

Prepare this chart for rendering.

=item set_dataset_domain_axis

  $chart->set_dataset_domain_axis($dataset_index, $axis_index)

Affines the dataset at the specified index to the domain axis at the second
index.

=item get_dataset_domain_axis

  my $axis = $chart->get_dataset_domain_axis($index)

Returns the domain axis to which the specified dataset is affined.

=item set_dataset_range_axis

  $chart->set_dataset_range_axis($dataset_index, $axis_index)

Affines the dataset at the specified index to the range axis at the second
index.

=item get_dataset_range_axis

  my $axis = $chart->get_dataset_range_axis($index)

Returns the range axis to which the specified dataset is affined.

=item write

Write the chart output to the specified location. Output is written in the
format provided to the constructor (which defaults to png).

  $c->write('/path/to/the.png');

=item data

Returns the data for this chart as a scalar.  Suitable for 'streaming' to a
client.

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
