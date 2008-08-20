package Chart::Clicker::Renderer::Measurement;
use Moose;

extends 'Chart::Clicker::Renderer';

sub prepare {
    die('Measurement is unsupported at the moment.');
}

# sub dontdraw {
#     my $self = shift();
#     my $clicker = shift();
#     my $cr = shift();
#     my $series = shift();
#     my $domain = shift();
#     my $range = shift();
# 
#     if (not $series->errors()) {
#         die('There are no error values in the series');
#     }
# 
#     my $height = $self->height();
# 
#     my @values = @{ $series->values() };
#     my @keys = @{ $series->keys() };
#     my @errors = @{ $series->errors() };
# 
#     my $color = $clicker->color_allocator->next();
#     $cr->set_source_rgba($color->rgba());
# 
#     # Draw the lines
#     $cr->set_line_width(1);
#     $cr->new_path();
# 
#     for(0..($series->key_count() - 1)) {
#         my $x = $domain->mark($keys[$_]);
#         my $y = $height - $range->mark($values[$_]);
#         if($_ == 0) {
#             $cr->move_to($x, $y);
#         } else {
#             $cr->line_to($x, $y);
#         }
#     }
#     $cr->stroke();
# 
#     # Draw the points
#     my $shape = Chart::Clicker::Shape::Arc->new({
#         radius => 3,
#         angle1 => 0,
#         angle2 => 360,
#     });
# 
#     $cr->new_path();
# 
#     for(0..($series->key_count() - 1)) {
#         my $x = $domain->mark($keys[$_]);
#         my $y = $height - $range->mark($values[$_]);
# 
#         $cr->move_to($x, $y);
#         $shape->create_path($cr, $x, $y);
#     }
#     $cr->fill();
# 
#     # Draw error bars
#     $cr->set_line_width(1);
#     $cr->new_path;
# 
#     for(0..($series->key_count() - 1)) {
#         my $x = $domain->mark($keys[$_]);
#         my $y = $height - $range->mark($values[$_]);
# 
#         $cr->move_to($x, $y);
#         $cr->rel_line_to(0, $range->per() * $errors[$_]);
#         $cr->rel_move_to(-3, 0);
#         $cr->rel_line_to(6, 0);
# 
#         $cr->move_to($x, $y);
#         $cr->rel_line_to(0, -$range->per() * $errors[$_]);
#         $cr->rel_move_to(-3, 0);
#         $cr->rel_line_to(6, 0);
#     }
#     $cr->stroke();
# 
#     return 1;
# }

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Measurement

=head1 WARNING

Deprecated.

=head1 DESCRIPTION

Chart::Clicker::Renderer::Measurement renders a dataset as lines with points
and error bars.

=head1 SYNOPSIS

  # ...

=head1 METHODS

=head2 Instance Methods

=over 4

=item I<prepare>

Prepare the series.

=back

=head1 AUTHOR

Torsten Schoenfeld <tsch@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.

1;

