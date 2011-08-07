use Test::More;

BEGIN {
    use_ok('Chart::Clicker::Context');
}

my $c = Chart::Clicker::Context->new(name => 'default');

cmp_ok($c->name, 'eq', $c->name, 'name');

done_testing;