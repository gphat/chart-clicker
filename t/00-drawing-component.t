use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Component');
}


my $c = Chart::Clicker::Drawing::Component->new();
isa_ok($c, 'Chart::Clicker::Drawing::Component');
