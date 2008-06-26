use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Decoration');
}

my $dec = Chart::Clicker::Decoration->new();
isa_ok($dec, 'Chart::Clicker::Decoration');
