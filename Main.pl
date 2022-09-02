use strict;
use warnings;

package Main;

use lib qw(.);

use Action;
use Menu;
use Library;
use BookView;

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