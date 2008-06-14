use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Point');
}

my @xy = (25, 25);
my $point = new Chart::Clicker::Drawing::Point({ x => $xy[0], y => $xy[1] });
isa_ok($point, 'Chart::Clicker::Drawing::Point');
