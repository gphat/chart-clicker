package Chart::Clicker::Format;
use Moose::Role;

requires 'create_surface';
requires 'data';
requires 'write';

has 'surface' => (
    is => 'rw',
#    isa => 'Cairo::ImageSurface'
);

1;

__END__
=head1 NAME

Chart::Clicker::Format - Format role for Chart::Clicker

=head1 DESCRIPTION

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1), L<Chart::Clicker>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.