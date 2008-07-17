package Chart::Clicker::Format;
use Moose;
use MooseX::AttributeHelpers;

use IO::File;

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

sub create_surface {
    die('Implement Me!');
}

sub write {
    my ($self, $click, $file) = @_;

    my $cr = $click->cairo();
    $cr->show_page();

    $cr = undef;
    $click->clear_cairo();
    $self->clear_surface();

    my $fh = IO::File->new($file, 'w')
        or die("Unable to open '$file' for writing: $!");
    $fh->binmode(1);
    $fh->print($self->surface_data);
    $fh->close();
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;

__END__
=head1 NAME

Chart::Clicker::Format - Format for Chart::Clicker

=head1 DESCRIPTION

Base class for various output formats.

=head1 METHODS

=over 4

=item I<create_surface>

Create a new surface. Sublcasses must implement this.

=item I<write>

Write the surface data to a file.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1), L<Chart::Clicker>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.