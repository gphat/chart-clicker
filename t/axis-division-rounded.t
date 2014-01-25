use Test::More;

BEGIN {
    use_ok('Chart::Clicker::Axis');
}
my $label = 'Foo';

# Small Range
{
    my $axis = Chart::Clicker::Axis->new(
        label              => $label,
        orientation        => 'vertical',
        position           => 'left',
        tick_division_type => 'LinearRounded'
    );

    ok( defined( $axis->range() ), 'Has range' );

    $axis->range->lower(3);
    $axis->range->upper(105);
    is( $axis->ticks, '6', 'Default number of ticks' );
    is_deeply( $axis->divvy(), [ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 ], 'Nicely rounded tick values - medium scale' );
}

# Larger Range
{
    my $axis = Chart::Clicker::Axis->new(
        label              => $label,
        orientation        => 'vertical',
        position           => 'left',
        tick_division_type => 'LinearRounded'
    );
    $axis->range->lower(1);
    $axis->range->upper(999123421);
    is_deeply(
        $axis->divvy(),
        [ 0, 100000000, 200000000, 300000000, 400000000, 500000000,
          600000000, 700000000, 800000000, 900000000, 1000000000],

        'Nicely rounded tick values - large scale 5 ticks'
    );
}

# Large range, small tick count
{
    my $axis = Chart::Clicker::Axis->new(
        label              => $label,
        orientation        => 'vertical',
        position           => 'left',
        tick_division_type => 'LinearRounded'
    );
    $axis->range->lower(1);
    $axis->range->upper(999123421);
    $axis->ticks(3);
    is_deeply( $axis->divvy(), [ 0, 250000000, 500000000, 750000000, 1000000000 ],
        'Nicely rounded tick values - large scale 3 ticks' );
}

# Very small range below 1
{
    my $axis = Chart::Clicker::Axis->new(
        label              => $label,
        orientation        => 'vertical',
        position           => 'left',
        tick_division_type => 'LinearRounded'
    );
    $axis->range->lower(0.0072);
    $axis->range->upper(0.0078);
    $axis->ticks(3);
    is_deeply( $axis->divvy(), [ 0.0072, 0.0073, 0.0074, 0.0075, 0.0076, 0.0077, 0.0078 ],
        'Nicely rounded tick values - large scale 3 ticks' );
}

# Very small range above 1
{
    my $axis = Chart::Clicker::Axis->new(
        label              => $label,
        orientation        => 'vertical',
        position           => 'left',
        tick_division_type => 'LinearRounded'
    );
    $axis->range->lower(1.5672);
    $axis->range->upper(1.5679);
    $axis->ticks(4);
    is_deeply( $axis->divvy(), [ 1.5672, 1.5673, 1.5674, 1.5675, 1.5676, 1.5677, 1.5678, 1.5679 ],
        'Nicely rounded tick values - large scale 3 ticks' );
}

done_testing;
