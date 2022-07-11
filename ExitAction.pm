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

sub get_name {
    my $name =  "Exit";
    return($name);
}

sub get_class_name {
    return $_[0];
    # $_[0]->{$name};
}

sub should_exit{
    return(1);
}

1;