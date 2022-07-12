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

sub display_name {
    my $name =  "Exit";
    return($name);
}

sub should_exit{
    return(1);
}

1;