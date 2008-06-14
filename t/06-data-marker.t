use Test::More tests => 5;

BEGIN {
    use_ok('Chart::Clicker::Data::Marker');
}

my $dec = new Chart::Clicker::Data::Marker();
my $value = 12;
my $value2 = 13;
my $key = 14;
my $key2 = 15;

$dec->value($value);
ok($dec->value() eq $value, 'Value');
$dec->value2($value2);
ok($dec->value2() eq $value2, 'Value2');
$dec->key($key);
ok($dec->key() eq $key, 'Key');
$dec->key2($key2);
ok($dec->key2() eq $key2, 'Key2');
