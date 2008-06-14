use Test::More tests => 5;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Stroke');
}

my $stroke = new Chart::Clicker::Drawing::Stroke();
isa_ok($stroke, 'Chart::Clicker::Drawing::Stroke');

cmp_ok($stroke->width(), '==', 1, 'Default width');
cmp_ok($stroke->line_join(), 'eq', $Chart::Clicker::Drawing::Stroke::CC_LINE_JOIN_MITER, 'Default Line Join');
cmp_ok($stroke->line_cap(), 'eq', $Chart::Clicker::Drawing::Stroke::CC_LINE_CAP_BUTT, 'Default Line Cap');