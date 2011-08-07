use Test::More;

BEGIN {
    use_ok('Chart::Clicker::Renderer::Bubble');
}

my $rndr = Chart::Clicker::Renderer::Bubble->new;
ok(defined($rndr), 'new Bubble Renderer');
isa_ok($rndr, 'Chart::Clicker::Renderer::Bubble');

done_testing;