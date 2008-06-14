use Test::More tests => 3;

BEGIN {
    use_ok('Chart::Clicker::Simple');
    use_ok('Chart::Clicker::Renderer::Line');
}

my $simple = new Chart::Clicker::Simple({
    data => [
        {
            keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
            values  => [ 2, 6, 8, 3, 5, 9, 1, 3, 1, 7 ]
        },
        {
            keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
            values  => [ 4, 4, 5, 8, 12, 7, 0, 5, 4, 10 ]
        }
    ],
    domain_label    => 'Danes',
    range_label     => 'Footballs',
    renderer        => new Chart::Clicker::Renderer::Line(),
    format          => 'png'
});
ok(defined($simple));
