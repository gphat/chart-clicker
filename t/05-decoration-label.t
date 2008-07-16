use Test::More tests => 3;

BEGIN {
    use_ok('Chart::Clicker::Decoration::Label');
}

my $label = Chart::Clicker::Decoration::Label->new(
    text => 'Test', orientation => 'horizontal'
);
isa_ok($label, 'Chart::Clicker::Decoration::Label');
cmp_ok($label->text, 'eq', 'Test');