use Test::More tests => 5;

BEGIN { use_ok('Chart::Clicker'); }

my $chart = Chart::Clicker->new({ width => 100, height => 50 });
ok(defined($chart), 'new Chart');
isa_ok($chart, 'Chart::Clicker', 'isa Chart');

cmp_ok($chart->width, '==', 100, 'width');
cmp_ok($chart->height, '==', 50, 'height');
