# Controller

use strict;
use warnings;
package DeleteBookAction;
use Action;
our @ISA = qw(Action);

sub execute {
    my $delete_type = BookView->findBook();
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

sub getName {
    #my $name =  $_[0];
    my $name = "Delete book";
    return($name);
}

sub shouldExit{
    return(0);
}

1;