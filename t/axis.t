use Test::More;

BEGIN {
    use_ok('Chart::Clicker::Axis');
}
my $label = 'Foo';

# Exact tick_division_type by default
my $axis = Chart::Clicker::Axis->new(
    label => $label, orientation => 'vertical', position => 'left'
);

cmp_ok($axis->format_value(100), 'eq', '100', 'format_value (default format test)');

ok($axis->label eq $label, 'label');

ok($axis->show_ticks, 'Default show_ticks');
ok($axis->visible, 'Default visible');

my $showticks = 0;
$axis->show_ticks($showticks);
ok($axis->show_ticks == $showticks, 'show_ticks');

my $vis = 0;
$axis->visible($vis);
ok($axis->visible == $vis, 'visible');

ok(defined($axis->range), 'Has range');

my $lower = 0;
my $upper = 100;
$axis->range->lower($lower);
$axis->range->upper($upper);
ok($axis->range->lower == $lower, 'Lower value');
ok($axis->range->upper == $upper, 'Upper value');

done_testing;
