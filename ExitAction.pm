# Controller

use strict;
use warnings;
package ExitAction;
use Action;
our @ISA = qw(Action);


sub execute{
    print("Exiting the program...\n");
    exit();
}

sub getName {
    my $name =  "Exit";
    return($name);
}

sub shouldExit{
    return(1);
}

1;