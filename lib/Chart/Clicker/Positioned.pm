package Chart::Clicker::Positioned;
use Moose::Role;

# ABSTRACT: Role for components that care about position.

use Moose::Util::TypeConstraints;

enum 'Chart::Clicker::Position' => qw(left right top bottom);

=head1 DESCRIPTION

Some components draw differently depending on which 'side' they are
positioned.  If an Axis is on the left, it will put the numbers left and the
bar on the right.  If positioned on the other side then those two piece are
reversed.

=head1 SYNOPSIS

    package My::Component;
    use Moose;

    extends 'Chart::Clicker::Drawing::Component';

    with 'Chart::Clicker::Positioned';

    1;

=attr position

The 'side' on which this component is positioned.

=cut

has 'position' => (
    is => 'rw',
    isa => 'Chart::Clicker::Position'
);

=method is_left

Returns true if the component is positioned left.

=cut

sub is_left {
    my ($self) = @_;

    return $self->position eq 'left';
}

=method is_right

Returns true if the component is positioned right.

=cut

sub is_right {
    my ($self) = @_;

    return $self->position eq 'right';
}

=method is_top

Returns true if the component is positioned top.

=cut

sub is_top {
    my ($self) = @_;

    return $self->position eq 'top';
}

=method is_bottom

Returns true if the component is positioned bottom.

=cut

sub is_bottom {
    my ($self) = @_;

    return $self->position eq 'bottom';
}

no Moose;
1;