use strict;
use warnings;

package Main;

use lib qw(.);

use Action;
use Menu;
use Library;

# this is the menu that will be displayed (1 - Add a book; 2 - Edit a book; 3 -  Find a book..)

#   declaring an instance $menu of a class "Menu" through the new() method, which is used for initialization
my $menu = Menu->new();

my $exit_condition = 0;
while($exit_condition == 0){

    # да се проверява за конретна инстанция (конкретен тип) на action
    #   instance of "Menu" performs the action => it should be OK
    my $action_decision = $menu->selectAction();
    # $action_decision -> what is chosen from the displayed values in the console (Add book; Delete book; Find book);
    my $class_instance = "";
    if($action_decision eq "Add a book"){
        $class_instance = AddBookAction->new();
    }
    elsif ($action_decision eq "Delete a book"){
        $class_instance = DeleteBookAction->new();
    }
    elsif ($action_decision eq "Edit a book"){
        $class_instance = EditBookAction->new();
    }
    elsif ($action_decision eq "Find a book"){
        $class_instance = FindBookAction->new();
    }
    elsif ($action_decision eq "Exit"){
        $class_instance = ExitAction->new();
    }
    #my $class_name = Action->execute($action_decision);
    # action -> action_type module (AddBookAction.pm; DeleteBookAction.pm; EditBookAction.pm)
    $class_instance->execute();
    $exit_condition = $class_instance->shouldExit();
    # exit_action присвоява стойността на shouldExit метода на дадения клас

}


1;