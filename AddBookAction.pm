# Controller

use strict;
use warnings;


package AddBookAction;
use BookView;
use Library;
use Book;
use Action;
our @ISA = qw(Action);

sub execute {
    my $library = $_[1];
    my $ui = $_[2];

    my $book_object = $ui->collect_book_info();

    $ui->display_book($book_object);
    my $add_book_confirmed = $ui->confirm_add_book($book_object);

    if (defined($add_book_confirmed)) {
        my $book_is_duplicate = $library->check_book_duplicate($book_object);
        if (defined($book_is_duplicate)) {
            print("Book with ISBN $book_object->{'ISBN'} already added to the library\n");
        }
        else {
            $library->add_book($book_object);
            print("Book successfully added to the library!\n")
        }

    }
    else {
        print("Operation cancelled - Did not add the book to the library!\n");
    }
}


sub display_name {
    my $name = "Add a book";
    return $name;
}


sub should_exit {
    return (0);
}


1;
