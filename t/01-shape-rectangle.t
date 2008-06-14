use Test::More tests => 2;

BEGIN { use_ok('Chart::Clicker::Shape::Rectangle'); }

my $rec = new Chart::Clicker::Shape::Rectangle();
isa_ok($rec, 'Chart::Clicker::Shape::Rectangle');
