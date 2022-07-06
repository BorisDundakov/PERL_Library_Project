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
        print($num, " - ", $action->getName(), "\n");
        $num += 1;

    }
#    print "Enter action number:\n";


    sub setAuthor{
        my($self, $author) = @_;
        my $author_validation = $author =~ /^(?!\s*$).+/;
        $self->{author} = $author if (($author_validation) eq! "");
        return($self->{author});
    }


    print "Enter action number:\n";

    my $selectedIndex = -1;
    my $action_validation = "";

    while ($action_validation eq ""){
        $selectedIndex = <STDIN>;
        chomp($selectedIndex);

        $action_validation = $selectedIndex =~ /[1-5]/;

        if ($action_validation eq "") {
            print("Please enter a valid number!\n");
            $action_validation = "";

        }

    }


    # добави валидация тук!

    my $action = $actions[$selectedIndex - 1]->getClassName();
    return $action;
}


1;