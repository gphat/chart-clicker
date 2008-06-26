use Test::More tests => 23;

BEGIN { use_ok('Chart::Clicker::Data::Series'); }

my $series = Chart::Clicker::Data::Series->new();
ok(defined($series), 'new Chart::Clicker::Data::Series');
isa_ok($series, 'Chart::Clicker::Data::Series');

my $name = 'Foo';
$series->name($name);
ok($series->name() eq $name, 'Name');

my @values = (1, 2, 10);
$series->values(\@values);
my $svals = $series->values();
ok(defined($svals), 'Values set');
cmp_ok($values[0], '==', $svals->[0], 'Value 0');
cmp_ok($values[1], '==', $svals->[1], 'Value 1');
cmp_ok($values[2], '==', $svals->[2], 'Value 2');

eval {
    $series->prepare();
};
ok(defined($@), 'Fail when keycount != valuecount');

my @keys = ('Uno', 'Dos', 'Tres');
$series->keys(\@keys);
my $skeys = $series->keys();
ok(defined($skeys), 'Keys set');
cmp_ok($keys[0], 'eq', $skeys->[0], 'Key 0');
cmp_ok($keys[1], 'eq', $skeys->[1], 'Key 1');
cmp_ok($keys[2], 'eq', $skeys->[2], 'Key 2');

eval {$series->prepare(); };
ok(!$@, 'Series prepare()');

cmp_ok($series->key_count(), '==', @keys, 'Key Count');
cmp_ok($series->value_count(), '==', @values, 'Value Count');
cmp_ok($series->range->lower(), '==', $values[0], 'Minimum Value');
cmp_ok($series->range->upper(), '==', $values[2], 'Maximum Value');
cmp_ok($series->range->span(), '==', 10, 'Span');

my $fooseries = Chart::Clicker::Data::Series->new({
    keys => [ 1, 2, 3, 4 ],
    values => [ 5, 6, 7, 14]
});
$fooseries->prepare();
ok($fooseries->keys->[0] == 1, 'Verify first key');
ok($fooseries->values->[0] == 5, 'Verify first value');
ok($fooseries->key_count() == 4, 'Verify key count');
cmp_ok($fooseries->range->span, '==', 10, 'Range');
