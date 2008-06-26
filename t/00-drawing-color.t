use Test::More tests => 11;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Color');
}

my @rgba = (1, .31, .25, 0);
my $color = Chart::Clicker::Drawing::Color->new({
    red     => $rgba[0],
    green   => $rgba[1],
    blue    => $rgba[2],
    alpha   => $rgba[3],
});
isa_ok($color, 'Chart::Clicker::Drawing::Color');

my $clone = $color->clone();
ok(defined($clone), 'Clone');

cmp_ok($clone->red(), '==', $color->red(), 'Clone Red');
cmp_ok($clone->green(), '==', $color->green(), 'Clone Green');
cmp_ok($clone->blue(), '==', $color->blue(), 'Clone Blue');
cmp_ok($clone->alpha(), '==', $color->alpha(), 'Clone Alpha');

cmp_ok($color->as_string(), 'eq', '1.00,0.31,0.25,0.00', 'as_string');
my @retrgba = $color->rgba();
cmp_ok(scalar(@retrgba), '==', 4, 'RGBA return');

my $red = Chart::Clicker::Drawing::Color->new({ name => 'red' });
ok(defined($red), 'Predefined Color');
ok($red->red() == 1.0, 'Red value');
