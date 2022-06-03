# Controller

use strict;
use warnings;

use Library;
use BookView;

package EditBookAction;
use Action;
our @ISA = qw(Action);

# КОДЪТ НАДОЛУ НЕ Е ВАЖЕН И НЕ Е ПРЕРАБОТВАН!

sub execute {
    my $search_type = BookView->findBook();
    if (defined($search_type)) {
        my $value = BookView->search();
        my $book = Library->edit_book($search_type, $value);
        if (!defined($book)) {
            print(BookView->noBookFound);
            return ();
        }
        my @res = BookView->editBook($book);
        # горното да е един обект
        my $result_to_add = $res[0];
        my $result_to_delete = $res[1];
        my $lib_args = ([ 'ISBN', $result_to_delete->{'ISBN'} ]);

        my %res = Library->add_book($result_to_add);
        if ($res{'is_duplicate'} eq "True") {
            if ($result_to_delete->{'ISBN'} eq $result_to_add->{'ISBN'}){
                my %book = Library->delete_book($lib_args);
                Library->add_book($result_to_add);
                print("Book changes saved!\n");
                return();
            }
            print("Book with ISBN $res{'ISBN'} already added to the library\n");
            print("Did not commit the changes!\n");
        }
        else {
            my %book = Library->delete_book($lib_args);
            print("Book changes saved!\n")
        }

    }
}


sub getName {
    my $name = "Edit book";
    return ($name);
}

sub shouldExit{
    return(0);
}

1;
