use Test::More tests => 4;

use Graphics::Color::RGB;

BEGIN {
    use_ok('Chart::Clicker::Drawing::ColorAllocator');
}

my @seedcolors = (
    Graphics::Color::RGB->new({
        red     => 0,
        green   => 0,
        blue    => 0,
        alpha   => 1,
        name    => 'black'
    })
);
my $ca = Chart::Clicker::Drawing::ColorAllocator->new({
    colors => \@seedcolors
});
isa_ok($ca, 'Chart::Clicker::Drawing::ColorAllocator');
my $shouldbeblack = $ca->next();
ok(defined($shouldbeblack), 'Seeded color seems to be there');
cmp_ok($shouldbeblack->name(), 'eq', 'black', 'Seeded color is black');

