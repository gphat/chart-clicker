use Test::More tests => 6;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Font');
}

use Chart::Clicker::Drawing::Font qw(:weights :slants);

my $font = new Chart::Clicker::Drawing::Font();
isa_ok($font, 'Chart::Clicker::Drawing::Font');

cmp_ok($font->size(), '==', 12, 'Default Size');
cmp_ok($font->face(), 'eq', 'Sans', 'Default Face');
cmp_ok($font->weight(), 'eq', $CC_FONT_WEIGHT_NORMAL, 'Default Weight');
cmp_ok($font->slant(), 'eq', $CC_FONT_SLANT_NORMAL, 'Default Slant');
