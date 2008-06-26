use Test::More tests => 10;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Component');
    use_ok('Chart::Clicker::Drawing::Container');
    use_ok('Chart::Clicker::Drawing::Border');
    use_ok('Chart::Clicker::Drawing::Insets');
    use_ok('Chart::Clicker::Drawing::Stroke');
}

eval {
    my $foo = Chart::Clicker::Drawing::Container->new();
};
ok(!defined($@) || ($@ eq ''), 'Failed w/no width and height');

my $c = Chart::Clicker::Drawing::Container->new({
    width => 300,
    height => 150,
    insets => Chart::Clicker::Drawing::Insets->new({
        top => 1, bottom => 2,
        left => 3, right => 4
    }),
    border => Chart::Clicker::Drawing::Border->new({
        stroke => Chart::Clicker::Drawing::Stroke->new({
            width => 2
        })
    }),
});
isa_ok($c, 'Chart::Clicker::Drawing::Container');

ok($c->inside_height() == 143, 'Inside Height');
ok($c->inside_width() == 289, 'Inside Width');

my $comp = Chart::Clicker::Drawing::Component->new();
$c->add($comp);

my $comps = $c->components();
ok(defined($comps), 'Get components');
