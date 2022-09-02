use strict;
use warnings;

package Main;

use lib qw(.);

use Action;
use Menu;
use Library;
use BookView;
# this is the menu that will be displayed (1 - Add a book; 2 - Edit a book; 3 -  Find a book..)

# declaring an instance $menu of a class "Menu" through the new() method, which is used for initialization
my $menu = Menu->new();
my $user_interface = BookView->new();
my $library = Library->new();

my $existing_database = $library->check_for_database();
if (!defined($existing_database)) {
    $library->create_database();
}

my $exit_condition = 0;
while ($exit_condition == 0) {

    my $action = $menu->selectAction();
    $action->execute($library, $user_interface);
    $exit_condition = $action->should_exit();
}

1;