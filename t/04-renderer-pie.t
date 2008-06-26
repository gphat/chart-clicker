use Test::More tests => 3;

BEGIN {
    use_ok('Chart::Clicker::Renderer::Pie');
}

my $rndr = Chart::Clicker::Renderer::Pie->new();
ok(defined($rndr), 'new Pie Renderer');
isa_ok($rndr, 'Chart::Clicker::Renderer::Pie');
