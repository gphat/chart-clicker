use Test::More tests => 6;

BEGIN { use_ok('Chart::Clicker::Data::Marker'); }

my $marker = new Chart::Clicker::Data::Marker();
ok(defined($marker), 'new Chart::Clicker::Data::Marker');
isa_ok($marker, 'Chart::Clicker::Data::Marker', 'isa Chart::Data::Marker');
cmp_ok($marker->inside_color->red(), '==', 0, 'Default Inside Color Red');
cmp_ok($marker->color->red(), '==', 0, 'Default Color Red');
isa_ok($marker->stroke(), 'Chart::Clicker::Drawing::Stroke', 'Default Stroke');