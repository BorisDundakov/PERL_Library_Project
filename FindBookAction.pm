# Controller

use strict;
use warnings;

package FindBookAction;
use BookView;
use Library;
use Book;
use Action;
our @ISA = qw(Action);

# КОДЪТ НАДОЛУ НЕ Е ВАЖЕН И НЕ Е ПРЕРАБОТВАН!

sub execute {
    my $search_type = BookView->findBook();
    # find_book method да се choose_find_book method
    if (defined($search_type)) {
        my $value = BookView->search();

        my $lib_args = ([$search_type, $value]);
        my $book = Library->find_book($lib_args);
        if (defined($book)) {
            BookView->displayBook($book);
        }
        else{
            print("No such book found!\n");
        }
    }
    else{
        # да не те връща в началото
        print("Letter not valid!\n");
    }
}

sub getName {
    my $name = "Find book";
    return ($name);
}

sub shouldExit{
    return(0);
}

1;
