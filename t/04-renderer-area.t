use Test::More tests => 3;

BEGIN {
    use_ok('Chart::Clicker::Renderer::Area');
}

my $rndr = Chart::Clicker::Renderer::Area->new();
ok(defined($rndr), 'new Area Renderer');
isa_ok($rndr, 'Chart::Clicker::Renderer::Area');
