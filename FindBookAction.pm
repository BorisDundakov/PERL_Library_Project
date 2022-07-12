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
    my $search_type = BookView->find_book();
    # find_book method да се choose_find_book method
    if (defined($search_type)) {
        my $value = BookView->search();

        my $lib_args = ([$search_type, $value]);
        my $book = Library->find_book($lib_args);
        if (defined($book)) {
            BookView->display_book($book);
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

sub display_name {
    my $name = "Find book";
    return ($name);
}

sub should_exit{
    return(0);
}

1;
