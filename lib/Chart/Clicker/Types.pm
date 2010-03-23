package Chart::Clicker::Types;
use strict;

use MooseX::Types -declare => [qw(
    DivvyStrategy
)];

enum DivvyStrategy,
    (qw(even loose tight));

1;

=head1 NAME

Chart::Clicker::Types

=head1 DESCRIPTION

Various Moose types for use with Chart::Clicker

=head1 TYPES

=head2 DivvyStrategy

Strategies used for creating ticks.  Valid values are:

=over 4

=item even

Evenly divide the range by the tick number.

=item loose

Allow the maximum and minimum of the chart's range to be expanded to make
better ticks.  Probably the best.

=item tight

Don't allow the maximum and minimum to expand but still make nice ticks. Will
give you exact edges but an odd middle.

=back

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.


