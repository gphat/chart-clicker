use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Decoration');
}

my $dec = new Chart::Clicker::Decoration();
isa_ok($dec, 'Chart::Clicker::Decoration');
