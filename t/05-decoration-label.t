use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Decoration::Label');
}

# Test Moose coercion
my $label = new Chart::Clicker::Decoration::Label(color => 'black');
cmp_ok($label->color->red(), '==', 0, 'Red');