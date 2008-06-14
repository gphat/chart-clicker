use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Insets');
}

my @insets = (25, 25, 25, 25);
my $insets = new Chart::Clicker::Drawing::Insets({
    top     => $insets[0],
    bottom  => $insets[1],
    left    => $insets[2],
    right   => $insets[3]
});
isa_ok($insets, 'Chart::Clicker::Drawing::Insets');
