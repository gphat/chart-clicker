use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Dimension');
}

my $dim = new Chart::Clicker::Drawing::Dimension();
isa_ok($dim, 'Chart::Clicker::Drawing::Dimension');
