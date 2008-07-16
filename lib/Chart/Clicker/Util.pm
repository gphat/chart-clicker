package Chart::Clicker::Util;
use strict;

sub load {
    my $class = shift();

    my $instance = eval {
        eval "require $class";
        $class->new();
    };

    if($@) {
        print "$@\n";
        return undef;
    }

    return $instance;
}

no Moose;

1;
__END__
=head1 NAME

Chart::Clicker::Util - Utility Stuff

=head1 METHODS

=over 

=item I<load>

Loads and instantiates a class.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.