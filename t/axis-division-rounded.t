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
    is( $axis->ticks, '5', 'Default number of ticks' );
    is_deeply( $axis->divvy(), [ 25, 50, 75, 100 ], 'Nicely rounded tick values - medium scale' );
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
        [ 0, 200000000, 400000000, 600000000, 800000000, 1000000000 ],
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
    is_deeply( $axis->divvy(), [ 0, 400000000, 800000000 ], 'Nicely rounded tick values - large scale 3 ticks' );
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
    is_deeply( $axis->divvy(), [ 0.00725, 0.00750, 0.00775 ], 'Nicely rounded tick values - large scale 3 ticks' );
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
    is_deeply( $axis->divvy(), [ 1.5672, 1.5674, 1.5676, 1.5678 ], 'Nicely rounded tick values - large scale 3 ticks' );
}

done_testing;
