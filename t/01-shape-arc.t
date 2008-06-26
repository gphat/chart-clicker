use Test::More tests => 2;

BEGIN { use_ok('Chart::Clicker::Shape::Arc'); }

my $arc = Chart::Clicker::Shape::Arc->new();
isa_ok($arc, 'Chart::Clicker::Shape::Arc');
