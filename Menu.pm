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
        push(@actions, AddBookAction->new()),

        push(@actions, EditBookAction->new()),

        push(@actions, FindBookAction->new()),

        push(@actions, DeleteBookAction->new()),

        push(@actions, ExitAction->new()),
        \@actions,
    };
    $self = \@actions;
    bless $self, $class;

}


sub selectAction() {
    print "Choose action:\n";

    my $num = 1;

    foreach my $action (@actions) {
        print($num, " - ", $action->display_name(), "\n");
        $num += 1;

    }

    my $count_actions = @actions;

    print "Enter action number:\n";

    my $selectedIndex = -1;
    my $action_validation = undef;

    while (!defined $action_validation){
        $selectedIndex = <STDIN>;
        chomp($selectedIndex);


        # dynamically adding actions so that we don't use fix regex (1-5)

        my $pattern = join '|', 0 .. $count_actions;

        if ($selectedIndex =~m/^(?:$pattern)$/ ){
            $action_validation = 1;
        }
        else{
            print("Please enter a valid number!\n");
        }


    }

    my $action = $actions[$selectedIndex - 1]->get_class_name();
    return $action;
}


1;