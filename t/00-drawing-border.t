use Test::More tests => 4;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Border');
}

my $border = new Chart::Clicker::Drawing::Border();
isa_ok($border, 'Chart::Clicker::Drawing::Border');

ok(defined($border->stroke()), 'Default stroke');

my $b2 = new Chart::Clicker::Drawing::Border(color => 'red');
cmp_ok($b2->color->red(), '==', 1, 'Red from coercion');
