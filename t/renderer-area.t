use Test::More;

BEGIN {
    use_ok('Chart::Clicker::Renderer::Area');
}

my $rndr = Chart::Clicker::Renderer::Area->new;
ok(defined($rndr), 'new Area Renderer');
isa_ok($rndr, 'Chart::Clicker::Renderer::Area');

done_testing;