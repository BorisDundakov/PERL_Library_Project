use strict;
use warnings;
no warnings qw(experimental::smartmatch);

use Book;
package BookView;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
}

sub create_book {

    my $title;
    my $author;
    my $pages;
    my $pub_date;
    my $isbn;

    my $book = Book->new();

    my $title_validation = "";
    while ($title_validation eq "") {
        print("Enter a book title:\n");
        $title = <STDIN>;
        chomp($title);
        my $validation_result = $book->set_title($title);
        $title_validation = $validation_result;

        if (!defined($validation_result)) {
            print("Please specify the title of the book!\n");
            $title_validation = "";

        }

    }

    my $author_validation = "";
    while ($author_validation eq "") {
        print("Enter a book author:\n");
        $author = <STDIN>;
        chomp($author);
        my $validation_result = $book->set_author($author);
        $author_validation = $author;

        if (!defined($validation_result)) {
            print("Please specify the name of the author!\n");
            $author_validation = "";

        }

    }

    my $date_validation = "";
    while ($date_validation eq "") {
        print("Enter publication date:\n");
        $pub_date = <STDIN>;
        chomp($pub_date);
        my $validation_result = $book->set_publication_date($pub_date);
        $date_validation = $pub_date;

        if (!defined($validation_result)) {
            print("Invalid Publication Date! Date must be in one of the following formats: DD-MM-YYYY; DD/MM/YYYY; DD.MM.YYYY\n");
            $date_validation = "";

        }
    }

    my $pages_validation = "";
    while ($pages_validation eq "") {
        print("Enter number of pages:\n");
        $pages = <STDIN>;
        chomp($pages);
        my $validation_result = $book->set_n_pages($pages);
        $pages_validation = $pages;
        if (!defined($validation_result)) {
            print("Invalid value for pages! Pages must be a number!\n");
            $pages_validation = "";
        }

    }

    my $isbn_validation = "";
    while ($isbn_validation eq "") {
        print("Enter a book ISBN:\n");
        $isbn = <STDIN>;
        chomp($isbn);
        my $validation_result = $book->set_ISBN($isbn);
        $isbn_validation = $isbn;
        if (!defined($validation_result)) {
            print("Invalid ISBN! ISBN must be 10 or 13 symbols long and contain only numbers!\n");
            $isbn_validation = "";
        }
    }

    return ($book);

}
sub display_book($) {
    print("Book Details:\n");
    print("Author:\t$_[1]->{'author'}\n");
    print("Title:\t$_[1]->{'title'}\n");
    print("Publication Date:\t$_[1]->{'publication_date'}\n");
    print("Number of pages:\t$_[1]->{'n_pages'}\n");
    print("ISBN:\t$_[1]->{'ISBN'}\n");
    print("------------------------\n");

}

sub add_book_decision($) {
    my $answer = "";
    while () {
        print("Add new book with the following details? (Type Y or N)\n");
        $answer = <STDIN>;
        $answer =~ s/\R//g;
        $answer = uc($answer);

        SWITCH: {

            if ($answer eq "Y") {return (1)}
            if ($answer eq "N") {return (undef)}
            else {
                print("Please type 'Y' or 'N'\n");
            }
        }

    }

}

sub display_no_book_found {
    return ("No book with the corresponding parameters found!\n")
}


sub edit_book($) {
    if (!defined($_[1])) {
        print("No such book found!\n");
        return (undef);
    }
    display_book($_[1]);

    my $old_title = $_[1]->{'title'};
    my $old_author = $_[1]->{'author'};
    my $old_pub_date = $_[1]->{'publication_date'};
    my $old_pages = $_[1]->{'n_pages'};
    my $old_isbn = $_[1]->{'ISBN'};

    print("Do you want to change the title of the book? (Y or N): ");
    my $title_decision = <STDIN>;
    $title_decision =~ s/\R//g;
    if (uc($title_decision) eq ("N")) {
        print("Title kept at ", $_[1]->{'title'}, "\n");
    }
    else {
        print("Enter new title: \n");
        my $title = <STDIN>;
        $title =~ s/\R//g;
        $_[1]->{'title'} = $title
    }

    print("Do you want to change the author of the book? (Y or N): ");
    my $author_decision = <STDIN>;
    $author_decision =~ s/\R//g;
    if (uc($author_decision) eq ("N")) {
        print("Author kept at ", $_[1]->{'author'}, "\n");
    }
    else {
        print("Enter new author: \n");
        my $author = <STDIN>;
        $author =~ s/\R//g;
        $_[1]->{'author'} = $author
    }

    print("Do you want to change the number of pages of the book? (Y or N): ");
    my $pages_decision = <STDIN>;
    $pages_decision =~ s/\R//g;
    if (uc($pages_decision) eq ("N")) {
        print("Pages kept at ", $_[1]->{'n_pages'}, "\n");
    }
    else {
        print("Enter new amount of pages: \n");
        my $pages = <STDIN>;
        $pages =~ s/\R//g;
        $_[1]->{'n_pages'} = $pages
    }

    print("Do you want to change the publication date of the book? (Y or N): ");
    my $publication_date_decision = <STDIN>;
    $publication_date_decision =~ s/\R//g;
    if (uc($publication_date_decision) eq ("N")) {
        print("Publication date kept at ", $_[1]->{'publication_date'}, "\n");
    }
    else {
        print("Enter new publication date: \n");
        my $publication_date = <STDIN>;
        $publication_date =~ s/\R//g;
        $_[1]->{'publication_date'} = $publication_date
    }
    print("Do you want to change the ISBN of the book? (Y or N): ");
    my $isbn_decision = <STDIN>;
    $isbn_decision =~ s/\R//g;
    if (uc($isbn_decision) eq ("N")) {
        print("ISBN kept at ", $_[1]->{'ISBN'}, "\n");
    }
    else {
        print("Enter new ISBN: \n");
        my $isbn = <STDIN>;
        $isbn =~ s/\R//g;
        $_[1]->{'ISBN'} = $isbn;
    }

    my %instance_to_edit = (title => $old_title, author => $old_author, n_pages => $old_pages, publication_date => $old_pub_date, ISBN => $old_isbn);
    my @res;
    push(@res, $_[1]);
    push(@res, \%instance_to_edit);

    return (@res);
}
# sub find_book {
#     print("Which criteria do you want to search by?\n");
#     print("Type the corresponding letter ONLY! :\n");
#     print("a) Author\n");
#     print("b) Title\n");
#     print("c) ISBN\n");
#     print("Answer: ");
#     my $answer = <STDIN>;
#     $answer =~ s/\R//g;
#
#     given ($answer) {
#         when (uc($answer) eq "A") {return ('author')}
#         when (uc($answer) eq "B") {return ('title')}
#         when (uc($answer) eq "C") {return ('ISBN')}
#         default {return (undef)}
#     }
#
# }

sub search {
    print("Enter your value here: ");
    my $val = <STDIN>;
    $val =~ s/\R//g;
    return ($val);
}

1;
