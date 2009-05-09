use Test::More tests => 3;

BEGIN {
    use_ok('Chart::Clicker::Renderer::CandleStick');
}

my $rndr = Chart::Clicker::Renderer::CandleStick->new();
ok(defined($rndr), 'new CandleStick Renderer');
isa_ok($rndr, 'Chart::Clicker::Renderer::CandleStick');
