use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Decoration::Glass');
}
my $dec = new Chart::Clicker::Decoration::Glass();
isa_ok($dec, 'Chart::Clicker::Decoration::Glass');