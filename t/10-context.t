use Test::More tests => 3;

BEGIN {
    use_ok('Chart::Clicker::Context');
}

my $c = Chart::Clicker::Context->new(name => 'default');

cmp_ok($c->name, 'eq', $c->name, 'name');

$c->renderer('Area');
isa_ok($c->renderer, 'Chart::Clicker::Renderer::Area', 'renderer coercion');
