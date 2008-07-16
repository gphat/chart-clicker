package Chart::Clicker::Cairo;
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

around qw(move_to rel_move_to line_to rel_line_to) => sub {
    my ($cont, $class, $x, $y) = @_;

    $x = int($x) + .5 if $x > 0;
    $y = int($y) + .5 if $y > 0;

    $cont->($class, $x, $y);
};

around qw(rectangle) => sub {
    my ($cont, $class, $x, $y, $width, $height) = @_;

    $cont->($class, int($x) + .5, int($y) + .5, int($width), int($height));
};

no Moose;

1;

__END__

=head1 NAME

Chart::Clicker::Cairo

=head1 DESCRIPTION

Chart::Clicker::Cairo wraps the Context from Cairo.

=head1 SYNOPSIS

 my $cairo = Chart::Clicker::Cairo->new();

=head1 METHODS

This class wraps the move_to, rel_move_to and line_to to normalize the x and
y values.

=over 4

=item I<create>

Wraps and reblesses Cairo's create.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
