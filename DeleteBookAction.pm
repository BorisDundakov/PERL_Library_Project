# Controller

use strict;
use warnings;
package DeleteBookAction;
use Action;
our @ISA = qw(Action);

sub execute {
    my $delete_type = BookView->find_book();
    if (defined($delete_type)) {
        my $value = BookView->search();
        my $lib_args = ([ $delete_type, $value ]);
        my %book = Library->delete_book($lib_args);
        if ($book{'is_found'} eq "False"){
            print("No such book found!\n");
        }
        else{
            print("Book with $delete_type $value successfully deleted!\n")
        }

    }

}

sub get_name {
    #my $name =  $_[0];
    my $name = "Delete book";
    return($name);
}

sub get_class_name {
    return $_[0];
    # $_[0]->{$name};
}

sub should_exit{
    return(0);
}

1;