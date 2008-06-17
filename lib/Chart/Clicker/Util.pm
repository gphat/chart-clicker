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

1;