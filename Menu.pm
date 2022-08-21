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
#    print "Enter action number:\n";





    print "Enter action number:\n";

    my $selectedIndex = -1;
    my $action_validation = "";

    while ($action_validation eq ""){
        $selectedIndex = <STDIN>;
        chomp($selectedIndex);

        # TODO: Валидацията да позволява да се добавят нови actions, без да се променя regex-a

        $action_validation = $selectedIndex =~ /[1-5]/;

        if ($action_validation eq "") {
            print("Please enter a valid number!\n");
            $action_validation = "";

        }

    }

    my $action = $actions[$selectedIndex - 1]->get_class_name();
    return $action;
}


1;