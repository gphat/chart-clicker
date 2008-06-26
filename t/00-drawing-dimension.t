use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Dimension');
}

my $dim = Chart::Clicker::Drawing::Dimension->new();
isa_ok($dim, 'Chart::Clicker::Drawing::Dimension');
