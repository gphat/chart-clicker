#!/usr/bin/perl
use strict;

use Data::Dumper;
use File::Find;
use Perl::Critic;

my $path = shift() or die('Need a path');

my @files;
find({ wanted => \&wanted, no_chdir => 1 }, $path);

foreach my $file (@files) {
    my $critic = new Perl::Critic(
        -severity => 1,
        -profile => 'perlcriticrc',
        -verbosity => 10,
        -exclude => [
            'RequireRCSKeywords',
            'ProhibitParensWithBuiltins',
            'ProhibitUnlessBlocks',
            'RequireVersionVar',
            'ProhibitCascadingIfElse',
            'ProhibitAmbiguousNames',
            'ProhibitBuiltinHomonyms'
        ]
    );
    my @vios = $critic->critique($file);
    foreach my $vio (@vios) {
        print "$file: $vio";
    }
}

sub wanted {
    if($_ =~ /\.pm$/) {
        push(@files, $_);
    }
}
