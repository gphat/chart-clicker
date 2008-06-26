use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Decoration::Glass');
}
my $dec = Chart::Clicker::Decoration::Glass->new();
isa_ok($dec, 'Chart::Clicker::Decoration::Glass');