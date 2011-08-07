use Test::More;

BEGIN {
    use_ok('Chart::Clicker::Decoration::Grid');
}
my $dec = Chart::Clicker::Decoration::Grid->new;
isa_ok($dec, 'Chart::Clicker::Decoration::Grid');

done_testing;