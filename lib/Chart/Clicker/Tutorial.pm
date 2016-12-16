package Chart::Clicker::Tutorial;

use strict;
use warnings;

# ABSTRACT: A Tutorial for using Chart::Clicker

=head1 DESCRIPTION

This document aims to provide a tutorial for using Chart::Clicker.

=head1 DISCLAIMER

This is a work in progress. If you find errors or would like to make
contributions, drop me a line!

=begin :prelude

=head1 EXAMPLES

=head2 Simple chart from a single data source

    # grab the needed modules
    use Chart::Clicker;
    use Chart::Clicker::Data::Series;
    use Chart::Clicker::Data::DataSet;

    # build the chart
    my $chart = Chart::Clicker->new;

    # build the series (static here, will usually be supplied arrayrefs from elsewhere)
    my $series = Chart::Clicker::Data::Series->new(
        keys	=>	[ 1,2,3,4,5 ],
        values	=>	[ 52,74,52,82,14 ],
    );

    # build the dataset
    my $dataset = Chart::Clicker::Data::DataSet->new(
        series	=>	[ $series ],
    );

    # add the dataset to the chart
    $chart->add_to_datasets($dataset);

    # write the chart to a file
    $chart->write_output('chart.png');

=head2 Simple chart from multiple data sources

    use Chart::Clicker;
    use Chart::Clicker::Data::Series;
    use Chart::Clicker::Data::DataSet;

    my $chart = Chart::Clicker->new;

    # start an array that will hold the series data
    my $series1 = Chart::Clicker::Data::Series->new(
        keys    =>      [ 1,2,3,4,5 ],
        values  =>      [ 52,74,52,82,14 ]
    );
    my $series2 = Chart::Clicker::Data::Series->new(
        keys	=>	[ 1,2,3,4,5 ],
        values	=>	[ 34,67,89,45,67 ]
    );

    # add the array of series data to the dataset
    my $dataset = Chart::Clicker::Data::DataSet->new(
        series  => [ $series1, $series2 ]
    );

    $chart->add_to_datasets($dataset);

    $chart->write_output('chart.png');

=head2 Simple chart with multiple data sources and custom colors

    use Chart::Clicker;
    use Chart::Clicker::Data::Series;
    use Chart::Clicker::Data::DataSet;
    # some new modules, these are only needed if you want to monkey with color changing
    use Graphics::Color::RGB;
    use Chart::Clicker::Drawing::ColorAllocator;

    # build the color allocator
    my $ca = Chart::Clicker::Drawing::ColorAllocator->new;
    # this hash is simply here to make things readable and cleaner, you can always call G::C::R inline
    my $red = Graphics::Color::RGB->new({
        red => .75, green => 0, blue => 0, alpha => .8
    });
    my $green = Graphics::Color::RGB->new({
        red => 0,green => .75, blue=> 0, alpha=> .8
    });
    my $blue = Graphics::Color::RGB->new({
        red => 0, green => 0, blue => .75, alpha => .8
    }),

    my $chart = Chart::Clicker->new;

    # Create an empty dataset that we can add to
    my $dataset = Chart::Clicker::Data::DataSet->new;

    $dataset->add_to_series(Chart::Clicker::Data::Series->new(
        keys    => [ 1,2,3,4,5 ],
        values  => [ 52,74,52,82,14 ]
    ));
    # add a color - note that the order of colors and the order of the
    # series must match, the first series will use the first color and so on
    # see contexts and axes for alternate ways of doing this
    $ca->add_to_colors($blue);

    $dataset->add_to_series(Chart::Clicker::Data::Series->new(
        keys    =>  [ 1,2,3,4,5 ],
        values   =>  [ 34,67,89,45,67 ]
    ));
    # add a second color
    $ca->add_to_colors($red);

    $dataset->add_to_series(Chart::Clicker::Data::Series->new(
        keys    =>  [ 1,2,3,4,5 ],
        values  =>  [ 11,22,33,44,55 ]
    ));
    # add a third color
    $ca->add_to_colors($green);

    $chart->add_to_datasets($dataset);

    # assign the color allocator to the chart
    $chart->color_allocator($ca);

    $chart->write_output('chart.png');

=head2 Example 4 : Simple chart with a different render type

    use Chart::Clicker;
    use Chart::Clicker::Data::Series;
    use Chart::Clicker::Data::DataSet;
    # add in the module of the renerer(s) you want to use
    use Chart::Clicker::Renderer::Area;

    my $chart = Chart::Clicker->new;

    my $series = Chart::Clicker::Data::Series->new(
        keys    => [ 1,2,3,4,5 ],
        values  => [ 52,74,52,82,14 ]
    );

    my $dataset = Chart::Clicker::Data::DataSet->new(
        series  => [ $series ]
    );

    $chart->add_to_datasets($dataset);

    # build the renderer to use
    my $renderer = Chart::Clicker::Renderer::Area->new(
        opacity => .75,
    );

    # assign the renderer to the default context
    $chart->set_renderer($renderer);

    $chart->write_output('chart.png');

=head2 Example 5 : Width and Height

  my $chart = Chart::Clicker->new(width => 1024, height => 768);

=head2 Example 6 : PDF (or SVG or PS)

  my $chart = Chart::Clicker->new(format => 'pdf');

  # Create the rest of your chart normally

  $chart->write_output('chart.pdf');

=head2 Example 7 : Hide the Legend and X-Axis

  my $chart = Chart::Clicker->new;

  # hide the legend
  $chart->legend->visible(0);

  # hide the X-Axis
  $chart->get_context('default')->domain_axis->hidden(1);

=head2 Example 8 : Change the display format of the Y-Axis

  my $chart = Chart::Clicker->new;

  # a sprintf format to have 3 decimal places showing on the Y-Axis
  $chart->get_context('default')->range_axis->format('%.3f');

=begin :postlude

=head1 CONTRIBUTORS

Steve Bradford

Michael Peters

=end :postlude

=cut

1;
