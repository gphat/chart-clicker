use Test::More tests => 3;

BEGIN {
    use_ok('Chart::Clicker::Util');
}

my $png = Chart::Clicker::Util::load('Chart::Clicker::Format::Png');
ok(defined($png), 'Class is defined.');
ok(ref($png) eq 'Chart::Clicker::Format::Png', 'Got right class.');