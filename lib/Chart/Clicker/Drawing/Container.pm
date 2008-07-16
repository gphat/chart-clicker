package Chart::Clicker::Drawing::Container;
use Moose;
use MooseX::AttributeHelpers;

extends 'Graphics::Primitive::Container';

no Moose;

1;
__END__
=head1 NAME

Chart::Clicker::Drawing::Container

=head1 DESCRIPTION

A Base 'container' for all components that want to hold other components.

=head1 SYNOPSIS

  my $c = Chart::Clicker::Drawing::Container->new({
    width => 500, height => 350
    background_color => 'white',
    border => Chart::Clicker::Drawing::Border->new(),
    insets => Chart::Clicker::Drawing::Insets->new(),
  });

=cut

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

  my $c = Chart::Clicker::Drawing::Container->new({
    width => 500, height => 350
    background_color => 'white',
    border => Chart::Clicker::Drawing::Border->new(),
    insets => Chart::Clicker::Drawing::Insets->new(),
  });

Creates a new Container.  Width and height must be specified.  Border,
background_color and insets are all optional and will default to undef

=back

=head2 Instance Methods

=over 4

=item I<width>

Set/Get this Container's height

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1), L<Graphics::Primitive>, L<Layout::Manager>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
