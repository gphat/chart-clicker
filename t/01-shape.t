use Test::More tests => 2;

BEGIN { use_ok('Chart::Clicker::Shape'); }

my $shape = Chart::Clicker::Shape->new();
isa_ok($shape, 'Chart::Clicker::Shape');
