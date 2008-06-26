use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Decoration::Label');
}

# Test Moose coercion
my $label = Chart::Clicker::Decoration::Label->new(color => 'black');
cmp_ok($label->color->red(), '==', 0, 'Red');