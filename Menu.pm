# View

use strict;
use warnings;

my @actions;
use AddBookAction;
use EditBookAction;
use FindBookAction;
use DeleteBookAction;
use ExitAction;

package Menu;

sub new {
    my $class = shift;
    my $self = {
        push(@actions, AddBookAction->getName()),

        push(@actions, EditBookAction->getName()),

        push(@actions, FindBookAction->getName()),

        push(@actions, DeleteBookAction->getName()),

        push(@actions, ExitAction->getName()),
        \@actions,
    };
    $self = \@actions;
    bless $self, $class;

}


sub selectAction() {
    print "Choose action:\n";

    # in print_actions() method

    my $num = 1;


    foreach my $action (@actions) {
        print($num, " - ", $action, "\n");
        $num += 1;

    }
    #
    print "Enter action number:\n";

    my $selectedIndex = <STDIN>;
    my $action = $actions[$selectedIndex - 1];
    return $action;
}


1;