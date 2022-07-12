use strict;
use warnings;

package Action;

sub new {
    my $class = $_[0];
    my $self = {};
    bless $self, $class;
    return $self;
}

sub execute($) {
}

sub display_name {
}

sub get_class_name {
    return $_[0];
}


sub should_exit() {
    # метод наследен от всички наследници на action (polymorphism):
    # AddBookAction, EditBookAction, FindBookAction, DeleteAction, ExitAction
    # returns 1/0
}

1;
