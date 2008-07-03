package Chart::Clicker::Context;
use Moose;

use Moose::Util::TypeConstraints;

use Chart::Clicker::Axis;
use Chart::Clicker::Drawing qw(:positions);
use Chart::Clicker::Renderer::Line;
use Chart::Clicker::Util;

subtype 'Renderer'
    => as 'Chart::Clicker::Renderer';

coerce 'Renderer'
    => from 'Str'
    => via {
        return Chart::Clicker::Util::load('Chart::Clicker::Renderer::'.$_)
    };

has 'domain_axis' => (
    is => 'rw',
    isa => 'Chart::Clicker::Axis',
    default => sub {
        Chart::Clicker::Axis->new(
            orientation => $CC_HORIZONTAL,
            position    => $CC_BOTTOM,
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
            orientation => $CC_VERTICAL,
            position    => $CC_LEFT,
            format      => '%0.2f'
        )
    }
);

has 'renderer' => (
    is => 'rw',
    isa => 'Renderer',
    default => sub { Chart::Clicker::Renderer::Line->new },
    coerce => 1
);

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
