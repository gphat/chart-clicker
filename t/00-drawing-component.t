use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Component');
}


my $c = new Chart::Clicker::Drawing::Component();
isa_ok($c, 'Chart::Clicker::Drawing::Component');
