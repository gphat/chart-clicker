use Test::More tests => 3;

use Chart::Clicker::Data::Series;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Renderer::Point;
use Chart::Clicker::Axis::DateTime;

BEGIN {
    use_ok('Chart::Clicker');
}

my $cc = Chart::Clicker->new;
isa_ok($cc, 'Chart::Clicker');

my $now = time;
my $hour = 3600;

my @values = (42, 25, 86, 23, 2, 19, 103, 12, 54, 9);

my $vcount = scalar(@values);
my $series = Chart::Clicker::Data::Series->new;
for(my $i = 0; $i <= $vcount; $i++) {
    $series->add_to_keys($now - ($hour * ($vcount - $i)));
    $series->add_to_values($values[$i - 1]);
}
# $series->add_to_keys(time - 3600);
# $series->add_to_values(50);


my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series ]);

$cc->add_to_datasets($ds);

my $ctx = $cc->get_context('default');
$ctx->domain_axis(Chart::Clicker::Axis::DateTime->new(position => 'bottom', orientation => 'horizontal'));
my $mark = Chart::Clicker::Data::Marker->new(key => 5, key2 => 6);
$mark->brush->color(Graphics::Color::RGB->new(red => 1, green => 0, blue => 0, alpha => 1));
$mark->inside_color(Graphics::Color::RGB->new(red => .5, green => .5, blue => .5, alpha => .5));
$ctx->add_marker($mark);

my $mark2 = Chart::Clicker::Data::Marker->new(value => 40, value2 => 60);
$mark2->brush->color(Graphics::Color::RGB->new(red => 1, green => 0, blue => 0, alpha => 1));
$mark2->inside_color(Graphics::Color::RGB->new(red => .5, green => .5, blue => .5, alpha => .5));
$ctx->add_marker($mark2);

$cc->draw;
my $data = $cc->data;
ok(defined($data), 'data');
