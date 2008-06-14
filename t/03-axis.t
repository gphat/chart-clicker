use Test::More tests => 11;

BEGIN {
    use_ok('Chart::Clicker::Axis');
}
my $label = 'Foo';

my $axis = new Chart::Clicker::Axis({ label => $label });

ok($axis->label() eq $label, 'label()');

ok($axis->show_ticks(), 'Default show_ticks()');
cmp_ok($axis->tick_length(), '>', 0, 'Default tick_length()');
ok($axis->visible(), 'Default visible');

my $showticks = 0;
$axis->show_ticks($showticks);
ok($axis->show_ticks() == $showticks, 'show_ticks()');

my $ticklen = 5;
$axis->tick_length($ticklen);
ok($axis->tick_length() == $ticklen, 'tick_length()');

my $vis = 0;
$axis->visible($vis);
ok($axis->visible() == $vis, 'visible()');

ok(defined($axis->range()), 'Has range');

my $lower = 0;
my $upper = 100;
$axis->range->lower($lower);
$axis->range->upper($upper);
ok($axis->range->lower() == $lower, 'Lower value');
ok($axis->range->upper() == $upper, 'Upper value');
