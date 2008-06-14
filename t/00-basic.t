use Test::More tests => 5;

BEGIN { use_ok('Chart::Clicker'); }

my $chart = new Chart::Clicker({ width => 100, height => 50 });
ok(defined($chart), 'new Chart');
isa_ok($chart, 'Chart::Clicker', 'isa Chart');

ok($chart->width() == 100, 'width');
ok($chart->height() == 50, 'height');
