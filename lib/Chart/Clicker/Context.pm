package Chart::Clicker::Context;
use Moose;

use Moose::Util::TypeConstraints;

use Chart::Clicker;
use Chart::Clicker::Axis;
use Chart::Clicker::Drawing qw(:positions);
use Chart::Clicker::Renderer::Line;
use Chart::Clicker::Util;

has 'domain_axis' => (
    is => 'rw',
    isa => 'Chart::Clicker::Axis',
    default => sub {
        Chart::Clicker::Axis->new(
            orientation => 'horizontal',
            position    => 'bottom',
            format      => '%0.2f'
        )
    }
);

has 'name' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

has 'range_axis' => (
    is => 'rw',
    isa => 'Chart::Clicker::Axis',
    default => sub {
        Chart::Clicker::Axis->new(
            orientation => 'vertical',
            position    => 'left',
            format      => '%0.2f'
        )
    }
);

has 'renderer' => (
    is => 'rw',
    isa => 'Chart::Clicker::Renderer',
    default => sub { Chart::Clicker::Renderer::Line->new },
    coerce => 1
);

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Context

=head1 DESCRIPTION

TODO

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Context object.

=back

=head2 Class Methods

=over 4

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
