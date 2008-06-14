use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Decoration::Grid');
}
my $dec = new Chart::Clicker::Decoration::Grid();
isa_ok($dec, 'Chart::Clicker::Decoration::Grid');
