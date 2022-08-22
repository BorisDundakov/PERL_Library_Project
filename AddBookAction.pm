# Controller

use strict;
use warnings;

# Usage of Inheritance and Polymorphism

package AddBookAction;
use BookView;
use Library;
use Book;
use Action;
our @ISA = qw(Action);
# AddBookAction inherits from Action


sub execute {
    my $library = Library->new();
    $library->check_for_database();

    my $bookView = BookView->new();

    my @book_details = $bookView->create_book();
    my $book_instance = Book->new(@book_details);

    $bookView->display_book($book_instance);
    my $answer = $bookView->add_book_decision($book_instance);

    # TODO: Code part 2: Database stuff, update information

    if ($answer eq ("Y")) {
        my %res = $library->check_book_duplicate($book_instance);
        if ($res{'is_duplicate'} eq "True") {
            print("Book with ISBN $res{'ISBN'} already added to the library\n");
        }
        else {
            $library->add_book($book_instance);
            print("Book successfully added to the library!\n")
        }

    }
    else{
        print("Operation cancelled - Did not add the book to the library!\n");
    }
}

#package AddBookAction;
sub display_name {
    my $name = "Add a book";
    return $name;
    # $_[0]->{$name};
}


sub should_exit{
    return(0);
}


1;
