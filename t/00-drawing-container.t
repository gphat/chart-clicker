use Test::More tests => 10;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Component');
    use_ok('Chart::Clicker::Drawing::Container');
    use_ok('Chart::Clicker::Drawing::Border');
    use_ok('Chart::Clicker::Drawing::Insets');
    use_ok('Chart::Clicker::Drawing::Stroke');
}

eval {
    my $foo = new Chart::Clicker::Drawing::Container();
};
ok(!defined($@) || ($@ eq ''), 'Failed w/no width and height');

my $c = new Chart::Clicker::Drawing::Container({
    width => 300,
    height => 150,
    insets => new Chart::Clicker::Drawing::Insets({
        top => 1, bottom => 2,
        left => 3, right => 4
    }),
    border => new Chart::Clicker::Drawing::Border({
        stroke => new Chart::Clicker::Drawing::Stroke({
            width => 2
        })
    }),
});
isa_ok($c, 'Chart::Clicker::Drawing::Container');

ok($c->inside_height() == 143, 'Inside Height');
ok($c->inside_width() == 289, 'Inside Width');

my $comp = new Chart::Clicker::Drawing::Component();
$c->add($comp);

my $comps = $c->components();
ok(defined($comps), 'Get components');
