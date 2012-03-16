use strict;
use Test::More;
use Test::Fatal;
use Chart::Clicker;

my @values = (42, 25, 86, 23, 2, 19, 103, 12, 54, 9);
my @keys = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

{
    my $cc = Chart::Clicker->new;

    foreach my $v (@values) {
        $cc->add_data('Sales', $v);
    }
    $cc->draw;
    is_deeply($cc->datasets->[0]->series->[0]->values, \@values, 'add_data scalar values');

    ok(defined($cc->rendered_data), 'rendered');
}

{
    my $cc = Chart::Clicker->new;

    my @vals1 = (42, 25, 86, 23, 2);
    my @vals2 = (19, 103, 12, 54, 9);

    $cc->add_data('Sales', \@vals1);
    $cc->add_data('Sales', \@vals2);

    $cc->draw;
    is_deeply($cc->datasets->[0]->series->[0]->values, \@values, 'add_data arrayref values');

    ok(defined($cc->rendered_data), 'rendered');
}

{
    my $cc = Chart::Clicker->new;

    my $hashref = {
        1  => 42,
        2  => 25,
        3  => 86,
        4  => 23,
        5  => 2,
        6  => 19,
        7  => 103,
        8  => 12,
        9  => 54,
        10 => 9
    };

    $cc->add_data('Sales', $hashref);

    $cc->draw;
    is_deeply($cc->datasets->[0]->series->[0]->values, \@values, 'add_data hashref values');

    ok(defined($cc->rendered_data), 'rendered');
}

{
    my $cc = Chart::Clicker->new;

    my $hashref1 = {
        1  => 42,
        4  => 23,
        6  => 19,
        7  => 103,
    };
    my $hashref2 = {
        5  => 2,
        2  => 25,
        3  => 86,
        8  => 12,
        9  => 54,
        10 => 9
    };

    $cc->add_data('Sales', $hashref1);
    $cc->add_data('Sales', $hashref2);

    $cc->draw;
    is_deeply($cc->datasets->[0]->series->[0]->values, \@values, 'add_data multiple hashref values');

    ok(defined($cc->rendered_data), 'rendered');
}

{
    my $cc = Chart::Clicker->new;

    my @vals = (42, 25, 86, 23);
    my $hashref2 = {
        5  => 2,
        6  => 19,
        7  => 103,
        8  => 12,
        9  => 54,
        10 => 9
    };

    $cc->add_data('Sales', \@vals);
    $cc->add_data('Sales', $hashref2);

    $cc->draw;
    is_deeply($cc->datasets->[0]->series->[0]->values, \@values, 'add_data arrayref followed by hashref');

    ok(defined($cc->rendered_data), 'rendered');
}

{
    my $cc = Chart::Clicker->new;

    my $hashref = {
        1  => 42,
        2  => 25,
        3  => 86,
        4  => 23,
        5  => 2,
    };
    my @vals = (19, 103, 12, 54, 9);

    like(
        exception {
            $cc->add_data('Sales', $hashref);
            $cc->add_data('Sales', \@vals);
        },
        qr/Can't add arrayref data after adding hashrefs/,
        "Exception thrown if arrayref data added after hashref data",
    );
}

{
    my $cc = Chart::Clicker->new;

    my $hashref = {
        1  => 42,
        2  => 25,
        3  => 86,
        4  => 23,
        5  => 2,
    };
    my $val = 19;

    like(
        exception {
            $cc->add_data('Sales', $hashref);
            $cc->add_data('Sales', $val);
        },
        qr/Can't add scalar data after adding hashrefs/,
        "Exception thrown if scalar data added after hashref data",
    );
}

done_testing;
