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
    my $status;

    my $book_object = $ui->collect_book_info();

    $ui->display_book($book_object);
    my $add_book_confirmed = $ui->confirm_add_book($book_object);

    if (defined($add_book_confirmed)) {
        $status = $library->add_book($book_object);
        my $success = $status->is_successful();
        if (defined $success) {
            print($status->get_message());
        }
        else {
            print("Error!" + $status->get_message());
        }
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
