use Test::More tests => 10;

BEGIN {
    use_ok('Chart::Clicker::Drawing::ColorAllocator');
    use_ok('Chart::Clicker::Drawing::Color');
}

my $ca = Chart::Clicker::Drawing::ColorAllocator->new();
isa_ok($ca, 'Chart::Clicker::Drawing::ColorAllocator');

my $red = $ca->next();
ok(defined($red), 'First Color');
cmp_ok($red->name(), 'eq', 'red', 'First is red');
cmp_ok($red->red(), '==', 1.0, 'Red value');
my $green = $ca->next();
ok(defined($green), 'Second Color');
cmp_ok($green->name(), 'eq', 'green', 'Second is green');

my @seedcolors = (
    Chart::Clicker::Drawing::Color->new({
        red     => 0,
        green   => 0,
        blue    => 0,
        alpha   => 1,
        name    => 'black'
    })
);
my $ca2 = Chart::Clicker::Drawing::ColorAllocator->new({
    colors => \@seedcolors
});
my $shouldbeblack = $ca2->next();
ok(defined($shouldbeblack), 'Seeded color seems to be there');
cmp_ok($shouldbeblack->name(), 'eq', 'black', 'Seeded color is black');

