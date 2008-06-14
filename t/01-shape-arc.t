use Test::More tests => 2;

BEGIN { use_ok('Chart::Clicker::Shape::Arc'); }

my $arc = new Chart::Clicker::Shape::Arc();
isa_ok($arc, 'Chart::Clicker::Shape::Arc');
