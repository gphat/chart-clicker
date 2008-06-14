package Chart::Clicker::Axis::DateTime;
use Moose;

use Chart::Clicker::Data::Marker;
use Chart::Clicker::Drawing::Color;

use DateTime;
use DateTime::Set;

extends 'Chart::Clicker::Axis';

has 'format' => (
    is => 'rw',
    isa => 'Str'
);

has 'time_zone' => (
    is => 'rw',
    isa => 'Str'
);

override 'prepare' => sub {
     my $self = shift();

    my ($dstart, $dend);
    eval {
        $dstart = DateTime->from_epoch(epoch => $self->range->lower());
        $dend = DateTime->from_epoch(epoch => $self->range->upper());
    };

    if(!defined($dstart) || !defined($dend)) {
        $dstart = DateTime->now();
        $dend = DateTime->now();
    }

    my $dur = $dend - $dstart;

    unless(defined($self->format()) && length($self->format())) {
        if($dur->years()) {
            $self->format('%b %Y');
        } elsif($dur->months()) {
            $self->format('%d');
        } elsif($dur->weeks()) {
            $self->format('%d');
        } elsif($dur->days()) {
            $self->format('%m/%d %H:%M');
        } else {
            $self->format('%H:%M');
        }
    }

    super();

    my $clicker = shift();
    if(!defined($clicker)) {
        die('No clicker?')
    }

    my @markers = @{ $clicker->markers() };

    my $set = DateTime::Span->from_datetimes(
        start => $dstart, end => $dend
    );

    my $linecolor = new Chart::Clicker::Drawing::Color({
        red => 0, green => 0, blue => 0, alpha => .35
    });
    my $fillcolor = new Chart::Clicker::Drawing::Color({
        red => 0, green => 0, blue => 0, alpha => .10
    });

    my @dmarkers;
    my $day = $set->start->truncate(to => 'day');

    my $dayval;
    while($day < $set->end()) {
        if($set->contains($day)) {
            if(defined($dayval)) {
                push(@dmarkers,
                    new Chart::Clicker::Data::Marker({
                        key         => $dayval,
                        key2        => $day->epoch(),
                        color       => $linecolor,
                        inside_color=> $fillcolor,
                    })
                );
                $dayval = undef;
            } else {
                $dayval = $day->epoch();
            }
        }
        $day = $day->add(days => 1);
    }
    if($dayval) {
        push(@dmarkers,
            new Chart::Clicker::Data::Marker({
                key         => $dayval,
                key2        => $day->epoch(),
                color       => $linecolor,
                inside_color=> $fillcolor,
            })
        );
    }

    push(@dmarkers, @markers);
    $clicker->markers(\@dmarkers);

    return 1;
};

sub format_value {
    my $self = shift();
    my $value = shift();

    my %dtargs = (
        'epoch' => $value
    );
    if($self->time_zone()) {
        $dtargs{'time_zone'} = $self->time_zone();
    }
    my $dt = DateTime->from_epoch(%dtargs);

    return $dt->strftime($self->format());
}

1;
__END__

=head1 NAME

Chart::Clicker::Axis::DateTime

=head1 DESCRIPTION

A temporal Axis.  Requires DateTime and DateTime::Set.  Inherits from
Axis, so check the methods there as well.  Expects that times will be in
unix format.

=head1 SYNOPSIS

  my $axis = new Chart::Clicker::Axis::DateTime();

=head1 METHODS

=head2 Constructor

=over 4

=item Chart::Clicker::Axis::DateTime->new()

Creates a new DateTime Axis.

=back

=head2 Class Methods

=over 4

=item format

Set/Get the formatting string used to format the DateTime.  See DateTime's
strftime.

=item time_zone

Set/Get the time zone to use when creating DateTime objects!  Accepts an
object or a string ('America/Chicago').

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
