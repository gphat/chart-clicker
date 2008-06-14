use Test::More tests => 3;

BEGIN {
    use_ok('Chart::Clicker::Renderer::Base');
}

my $rndr = new Chart::Clicker::Renderer::Base();
ok(defined($rndr), 'new Renderer');
isa_ok($rndr, 'Chart::Clicker::Renderer::Base');
