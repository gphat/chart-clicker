#!/usr/bin/perl
use strict;

use Data::Dumper;
use File::Find;

my $path = shift() or die('Need a path');
my $output = shift() or die('Need output directory');
my @pparts = split(/\//, $path);

my @files;
find({ wanted => \&wanted, no_chdir => 1 }, $path);

unless(-e $output) {
    system("mkdir -p $output");
}
open(INDEX, ">$output/index.html");

print INDEX qq{
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<body>
 <ul>
};

foreach my $file (@files) {

    my @parts = split(/\//, $file);
    my @new;
    my $acc;
    for(my $i = 0; $i <= $#parts; $i++) {
        if($parts[$i] eq $pparts[$i]) {
            next;
        }

        push(@new, $parts[$i]);
    }
    my $new = join('/', @new);
    my $pm = $new;
    $new =~ s/\.pm$/\.html/;
    $new =~ s/\.pod$/\.html/;


    my @path = split(/\//, "$output/$new");
    pop(@path);
    my $p = join('/', @path);
    unless(-e $p) {
        system("mkdir -p $p\n");
    }
    $pm =~ s/\//::/g;
    $pm =~ s/\.pm//g;
    $pm =~ s/\.pod//g;
    print INDEX "   <li><a href=\"$new\">$pm</a></li>\n";
    system("pod2html --infile=$file --outfile=$output/$new\n");
}

print INDEX "  </ul>\n</body>\n</html>\n";

close(INDEX);

sub wanted {
    if($_ =~ /\.(pm|pod)$/) {
        push(@files, $_);
    }
}
