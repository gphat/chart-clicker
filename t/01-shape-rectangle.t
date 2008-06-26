use Test::More tests => 2;

BEGIN { use_ok('Chart::Clicker::Shape::Rectangle'); }

my $rec = Chart::Clicker::Shape::Rectangle->new();
isa_ok($rec, 'Chart::Clicker::Shape::Rectangle');
