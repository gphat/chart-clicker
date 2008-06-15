package Chart::Clicker::Context;
use Moose;

use Cairo;

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

1;

__END__

=head1 NAME

Chart::Clicker::Context

=head1 DESCRIPTION

Chart::Clicker::Context wraps the Context from Cairo.

=head1 SYNOPSIS

 my $context = Chart::Clicker::Context->new();

=head1 METHODS

This class wraps the move_to, rel_move_to and line_to to normalize the x and
y values.

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
