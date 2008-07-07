package Chart::Clicker::Drawing;
use Moose;

no Moose;
1;
__END__

=head1 NAME

Chart::Clicker::Drawing

=head1 DESCRIPTION

Chart::Clicker::Drawing holds some common items used in Drawing.

=head1 SYNOPSIS

  package Chart::Clicker::Component;
  extends 'Chart::Clicker::Drawing';
  
  sub draw {
      # Do stuff...
  }

=head1 METHODS

=over 4

=item I<orientation>

The orientration of this component.  See L<Graphics::Primitive::Oriented>.

=item I<is_horizontal>

Returns true if this component is to be laid out horizontally.

=item I<is_vertical>

Returns true if this component is to be laid out vertically.

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
