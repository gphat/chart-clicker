use Test::More;

BEGIN {
    use_ok('Chart::Clicker');
    use_ok('Chart::Clicker::Renderer::Bar');
    use_ok('Chart::Clicker::Renderer::Line');
}

my $chart = Chart::Clicker->new({ width => 100, height => 50 });
ok(defined($chart), 'new Chart');
isa_ok($chart, 'Chart::Clicker', 'isa Chart');

cmp_ok($chart->width, '==', 100, 'width');
cmp_ok($chart->height, '==', 50, 'height');

$chart->set_renderer(Chart::Clicker::Renderer::Bar->new);

isa_ok($chart->get_context('default')->renderer, 'Chart::Clicker::Renderer::Bar', 'set_renderer');

$chart->set_renderer(Chart::Clicker::Renderer::Line->new, 'default');

isa_ok($chart->get_context('default')->renderer, 'Chart::Clicker::Renderer::Line', 'set_renderer');

eval {
    $chart->set_renderer(Chart::Clicker::Renderer::Bar->new, 'foo');
};
ok(defined($@), 'non-existant context blew up');

done_testing;