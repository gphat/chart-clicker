package Chart::Clicker::Decoration::Plot;
use Moose;
use MooseX::AttributeHelpers;

use Layout::Manager::Single;
#use Chart::Clicker::Decoration::MarkerOverlay;

# TODO MOve this class?  It's not decoration anymore.
extends 'Chart::Clicker::Drawing::Container';

# TODO Temporary
has '+background_color' => ( default => sub { Graphics::Color::RGB->new( red => 1 ) });

has 'clicker' => (
    is => 'rw',
    isa => 'Chart::Clicker',
);

has '+layout' => (
    default => sub { Layout::Manager::Single->new }
);

has 'renderers' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [ ] },
    provides => {
        'push' => 'add_to_renderers',
        'get' => 'get_renderer'
    }
);

has 'markers' => (
    is => 'rw',
    isa => 'Bool',
    default => 1
);

has 'dataset_renderers' => (
    metaclass => 'Collection::Hash',
    is => 'rw',
    isa => 'HashRef',
    default => sub { {} },
    provides => {
        'set' => 'set_dataset_renderer',
        'get' => 'get_dataset_renderer'
    }
);

sub prepare {
    my ($self) = @_;
#     my $clicker = shift();
#     my $dimension = shift();
# 
#     # $self->width($dimension->width());
#     # $self->height($dimension->height());
# 
#     # my $idim = $self->inside_dimensions();
# 
    # my %dscount;
    # my %rend_ds;
    # my $count = 0;
    # foreach my $dataset (@{ $self->clicker->datasets() }) {
        # my $ridx = $self->get_dataset_renderer($count) || 0;
    #     $dscount{$ridx} += scalar(@{ $dataset->series() });
        # push(@{ $rend_ds{$ridx} }, $dataset);
        # $count++;
    # }
# 
    # TODO This is also happening in Clicker.pm
    foreach my $c (@{ $self->components }) {
        $c->{component}->clicker($self->clicker);
    }
# 
    super;
# 
#     # $count = 0;
#     # foreach my $rend (@{ $self->renderers() }) {
#     #     $rend->dataset_count($dscount{$count} || 0);
#     #     $rend->prepare($clicker, $idim, $rend_ds{$count});
#     #     $count++;
#     # }
# 
#     return 1;
}

# sub draw {
#     my $self = shift();
# 
#     my $cr = $self->clicker->cairo();
# 
#     my $count = 0;
#     foreach my $dataset (@{ $self->clicker->datasets() }) {
#         my $domain = $self->clicker->get_domain_axis(
#             $self->clicker->get_dataset_domain_axis($count) || 0
#         );
#         my $range = $self->clicker->get_range_axis(
#             $self->clicker->get_dataset_range_axis($count) || 0
#         );
#         my $ridx = $self->get_dataset_renderer($count);
#         my $rend = $self->get_renderer($ridx || 0);
# 
#         foreach my $series (@{ $dataset->series() }) {
#             $cr->save();
#             $rend->draw($clicker, $cr, $series, $domain, $range);
#             $cr->restore();
#         }
#         $count++;
#     }
# 
#     my $id = $self->inside_dimensions();
#     if($self->markers()) {
#         if(scalar(@{ $self->clicker->markers() })) {
#             my $mo = Chart::Clicker::Decoration::MarkerOverlay->new();
#             $mo->prepare($clicker, $id);
#             $cr->save;
#             $mo->draw($clicker);
#             $cr->restore();
#         }
#     }
# }

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::Plot

=head1 DESCRIPTION

A Component that handles the rendering of data via Renderers.  Also
handles rendering the markers that come from the Clicker object.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Plot object.

=cut
=back

=head2 Class Methods

=over 4

=item border

Set/Get this Plot's border.

=item insets

Set/Get this Plot's insets.

=item markers

Set/Get the flag that determines if markers are drawn on this plot.

=item renderers

Set/Get this Plot's renderers. Uses an arrayref.

=item set_renderer_for_dataset

Sets the Renderer to be used for a particular DataSet.  Uses indices:

  my @renderers = ($line, $bar);
  $plot->renderers(\@renderers);
  $plot->set_renderer_for_dataset(0, 0); # dataset idx, renderer idx
  $plot->set_renderer_for_dataset(1, 1);

If no renderer is set for a dataset the zeroth one is used.  See
L<get_renderer_for_dataset>.

=item get_renderer_for_dataset

Get the index of the renderer that will be used for the DataSet at the
specified index.

=item prepare

Prepare this Plot by determining how much space it needs.

=item draw

Draw this Plot

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
