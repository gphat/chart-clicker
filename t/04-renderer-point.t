use Test::More tests => 3;

BEGIN {
    use_ok('Chart::Clicker::Renderer::Point');
}

my $rndr = Chart::Clicker::Renderer::Point->new();
ok(defined($rndr), 'new Point Renderer');
isa_ok($rndr, 'Chart::Clicker::Renderer::Point');
