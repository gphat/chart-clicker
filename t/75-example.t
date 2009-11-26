use Test::More tests => 3;

use Chart::Clicker::Data::Series;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Renderer::Point;

BEGIN {
    use_ok('Chart::Clicker');
}

my $cc = Chart::Clicker->new;
isa_ok($cc, 'Chart::Clicker');

my $series = Chart::Clicker::Data::Series->new(
    keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
    values  => [ 42, 25, 86, 23, 2, 19, 103, 12, 54, 9 ],
);

my $series2 = Chart::Clicker::Data::Series->new(
    keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
    values  => [ 67, 15, 6, 90, 11, 45, 83, 11, 9, 101 ],
);

my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series, $series2 ]);

$cc->add_to_datasets($ds);

my $ctx = $cc->get_context('default');
my $mark = Chart::Clicker::Data::Marker->new(key => 5, key2 => 6);
$mark->brush->color(Graphics::Color::RGB->new(red => 1, green => 0, blue => 0, alpha => 1));
$mark->inside_color(Graphics::Color::RGB->new(red => .5, green => .5, blue => .5, alpha => .5));
$ctx->add_marker($mark);

my $mark2 = Chart::Clicker::Data::Marker->new(value => 40, value2 => 60);
$mark2->brush->color(Graphics::Color::RGB->new(red => 1, green => 0, blue => 0, alpha => 1));
$mark2->inside_color(Graphics::Color::RGB->new(red => .5, green => .5, blue => .5, alpha => .5));
$ctx->add_marker($mark2);

$cc->draw;
my $data = $cc->rendered_data;
ok(defined($data), 'data');
