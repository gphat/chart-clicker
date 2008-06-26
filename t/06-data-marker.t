use Test::More tests => 5;

BEGIN {
    use_ok('Chart::Clicker::Data::Marker');
}

my $dec = Chart::Clicker::Data::Marker->new();
my $value = 12;
my $value2 = 13;
my $key = 14;
my $key2 = 15;

$dec->value($value);
cmp_ok($dec->value(), 'eq', $value, 'Value');
$dec->value2($value2);
cmp_ok($dec->value2(), 'eq', $value2, 'Value2');
$dec->key($key);
cmp_ok($dec->key(), 'eq', $key, 'Key');
$dec->key2($key2);
cmp_ok($dec->key2(), 'eq', $key2, 'Key2');
