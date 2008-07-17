package Chart::Clicker::Context;
use Moose;

use Moose::Util::TypeConstraints;

use Chart::Clicker;
use Chart::Clicker::Axis;
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

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Context

=head1 DESCRIPTION

Contexts represent the way a dataset should be charted.  Multiple contexts
allow a chart with multiple renderers and axes.  See the CONTEXTS section
in L<Chart::Clicker>.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Context object.

=back

=head2 Instance Methods

=over 4

=item I<domain_axis>

Set/get this context's domain axis

=item I<name>

Set/get this context's name

=item I<range_axis>

Set/get this context's range axis

=item I<render>

Set/get this context's renderer

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
