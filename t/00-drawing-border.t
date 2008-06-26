use Test::More tests => 4;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Border');
}

my $border = Chart::Clicker::Drawing::Border->new();
isa_ok($border, 'Chart::Clicker::Drawing::Border');

ok(defined($border->stroke()), 'Default stroke');

my $b2 = Chart::Clicker::Drawing::Border->new(color => 'red');
cmp_ok($b2->color->red(), '==', 1, 'Red from coercion');
