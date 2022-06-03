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
    my $bookView = BookView->new();

    my @book_details = $bookView->createBook();
    my $book_instance = Book->new(@book_details);

    my $library = Library->new();
    $library->pull_database();

    $bookView->displayBook($book_instance);
    my $answer = $bookView->addBookDecision($book_instance);

    # TODO: Code part 2: Database stuff, update information

    if ($answer eq ("Y")) {
        my %res = $library->checkBookDuplicate($book_instance);
        if ($res{'is_duplicate'} eq "True") {
            print("Book with ISBN $res{'ISBN'} already added to the library\n");
        }
        else {
            $library->addBook($book_instance);
            print("Book successfully added to the library!\n")
        }

    }
    else{
        print("Operation cancelled - Did not add the book to the library!\n");
    }
}

#package AddBookAction;
sub getName {
    my $name = "Add a book";
    return $name;
    # $_[0]->{$name};
}

sub shouldExit{
    return(0);
}


1;
