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

    #1. Събери параметрите от потребителя като обект Книга

    my $book_object = $bookView->create_book();

    #1.1 Покажи събранните данни и искай потвърждение от потребителя

    $bookView->display_book($book_object);
    my $confirmation_answer = $bookView->add_book_decision($book_object);

    # TODO: Code part 2: Database stuff, update information

    #1.2 Ако данните от портебителя са потвърдени
    if (defined($confirmation_answer)) {
        #1.3 Тест за дубликация (вече налична такава книга)
        my $duplicate_test = $library->check_book_duplicate($book_object);
        if (defined($duplicate_test)) {
            print("Book with ISBN $book_object->{'ISBN'} already added to the library\n");
        }
        else {
            #2. Добави книгата в библиотеката
            $library->add_book($book_object);
            #3. Уведоми потребителя за резултата от добавянето
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
