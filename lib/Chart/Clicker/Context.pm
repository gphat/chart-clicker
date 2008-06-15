package Chart::Clicker::Context;
use Moose;

extends 'Cairo::Context';

sub create {
    my $proto = shift();
    my $class = ref($proto) || $proto;

    my $cairo = $class->SUPER::create(@_);
    $class->meta->rebless_instance($cairo);
    return $cairo;
}

around qw(move_to rel_move_to line_to) => sub {
    my ($cont, $class, $x, $y) = @_;

    $cont->($class, int($x) + .5, int($y) + .5);
};

# around 'rel_move_to' => sub {
#     my ($cont, $class, $x, $y) = @_;
# 
#     $cont->($class, int($x) + .5, int($y) + .5);
# };
# 
# around 'line_to' => sub {
#     my ($cont, $class, $x, $y) = @_;
#     $cont->($class, int($x) + .5, int($y) + .5);
# };

1;