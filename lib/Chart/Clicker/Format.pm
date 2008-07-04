package Chart::Clicker::Format;
use Moose::Role;
use MooseX::AttributeHelpers;

use IO::File;

# TODO This shouldn't be a role...

requires 'create_surface';

has 'surface' => (
    is => 'rw',
    clearer => 'clear_surface'
);

has 'surface_data' => (
    metaclass => 'String',
    is => 'rw',
    isa => 'Str',
    default => sub { '' },
    provides => {
        append => 'append_surface_data'
    },
);

sub write {
    my ($self, $click, $file) = @_;

    my $cr = $click->cairo();
    $cr->show_page();

    $cr = undef;
    $click->clear_context();
    $self->clear_surface();

    my $fh = IO::File->new($file, 'w')
        or die("Unable to open '$file' for writing: $!");
    $fh->binmode(1);
    $fh->print($self->surface_data);
    $fh->close();
}

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