# Controller

use strict;
use warnings;


package AddBookAction;
use BookView;
use Library;
use Book;
use Action;
use Status;
our @ISA = qw(Action);

sub execute {
    my $library = $_[1];
    my $ui = $_[2];
    my $status;
    my $message = Status->new();

    my $book_object = $ui->collect_book_info();

    $ui->display_book($book_object);
    my $add_book_confirmed = $ui->confirm_add_book($book_object);

    if (defined($add_book_confirmed)) {
        $status = $library->add_book($book_object);
        if ($status == 1) {
            print($message->successful_operation);
        }
        elsif ($status == 0) {
            print($message->book_duplicate($book_object->{'ISBN'}))
        }
    }
    else {
        print($message->cancelled_operation)

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
