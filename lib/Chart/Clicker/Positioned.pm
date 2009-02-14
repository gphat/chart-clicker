package Chart::Clicker::Positioned;
use Moose::Role;

use Moose::Util::TypeConstraints;

enum 'Chart::Clicker::Position' => qw(left right top bottom);

has 'position' => (
    is => 'rw',
    isa => 'Chart::Clicker::Position'
);

sub is_left {
    my ($self) = @_;

    return $self->position eq 'left';
}

sub is_right {
    my ($self) = @_;

    return $self->position eq 'right';
}

sub is_top {
    my ($self) = @_;

    return $self->position eq 'top';
}

sub is_bottom {
    my ($self) = @_;

    return $self->position eq 'bottom';
}

no Moose;
1;
__END__
=head1 NAME

Chart::Clicker::Positioned - Role for components that care about position.

=head1 SYNOPSIS

Some components draw differently depending on which 'side' they are
positioned.  If an Axis is on the left, it will put the numbers left and the
bar on the right.  If positioned on the other side then those two piece are
reversed.

    package My::Component;
    
    extends 'Chart::Clicker::Drawing::Component';
    
    with 'Chart::Clicker::Positioned';
    
    1;

=head1 METHODS

=head2 is_bottom

Returns true if the component is positioned bottom.

=head2 is_left

Returns true if the component is positioned left.

=head2 is_right

Returns true if the component is positioned right.

=head2 is_top

Returns true if the component is positioned top.

=head2 position

The 'side' on which this component is positioned.

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.