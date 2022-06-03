use strict;
use warnings;

package Action;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
}

sub execute($) {
}

sub shouldExit() {
    # метод наследен от всички наследници на action (polymorphism):
    # AddBookAction, EditBookAction, FindBookAction, DeleteAction, ExitAction
    # returns 1/0
}

1;
