use Test::More tests => 2;

BEGIN { use_ok('Chart::Clicker::Shape'); }

my $shape = new Chart::Clicker::Shape();
isa_ok($shape, 'Chart::Clicker::Shape');
