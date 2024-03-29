# Model

use strict;
use warnings;
package Library;
binmode STDOUT, ":utf8";
use JSON;
use Try::Tiny;
use JSON::Parse 'json_file_to_perl';
use Data::Structure::Util qw(unbless);

use Status;


sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
}


sub create_database {
    open(FileHandle, '>>C:\Users\User\IdeaProjects\PERL_Library_Project\Database.json');
    close FileHandle;
}

sub check_for_database {
    my $filename = 'C:\Users\User\IdeaProjects\PERL_Library_Project\Database.json';
    if (-e $filename) {
        return(0)
    }
    return(1)
}


sub get_books() {
    my $json;
    {
        open(my $fh, 'Database.json') or die("can't open Database.json\n");
        local $/;
        $json = <$fh>;
        close $fh;
    }
    my @objects_array = decode_json($json);

    my @books_array;
    my $index = 0;
    while (defined($objects_array[0][$index]))
    {

        # a perl_object is a regular hash
        # transforming regular hash to a hash of type Book

        my $author = $objects_array[0][$index]{'author'};
        # extracting the values just like from a dictionary
        my $title = $objects_array[0][$index]{'title'};
        my $publication_date = $objects_array[0][$index]{'publication_date'};
        my $n_pages = $objects_array[0][$index]{'n_pages'};
        my $ISBN = $objects_array[0][$index]{'ISBN'};

        my $book_object = Book->new($author, $title, $publication_date, $n_pages, $ISBN);
        $index += 1;
        push(@books_array,$book_object);

    }
    return(@books_array)
}

sub add_book($) {
    # should return the reason for the status
    # if operation is cancelled, the method will not even be called
    my $new_book = $_[1];
    my $ISBN = $new_book->{'ISBN'};
    my @books = get_books();
    my $add_book_status;

    # In Perl:
    # The number 0, the strings '0' and '', the empty list "()", and "undef"
    # are all false in a boolean context. All other values are true.
    #     Negation of a true value by "!" or "not" returns a special false
    #     value. When evaluated as a string it is treated as '', but as a number, it is treated as 0.
    #
    # From perlsyn under "Truth and Falsehood".


    #TODO: Затова е добре причината за статуса да се връща от самия add_book метод и да е конкретна.
    #TODO: Въпрос-> тоест add_book метода хем се опитва да добави книгата, хем връща какво се случило??

    #Методът add_book (ТРЯБВА ДА!??) връща обект от тип статус (а не число)
    # и в зависимост от това какво се обърка може да му сложи правилното съобщение.

    foreach my $current_book (@books) {
        # вътрешната проверка на add_book за duplicate
        if ($current_book->{'ISBN'} eq $new_book->{'ISBN'}){
            return Status->new(0,"Book with ISBN $ISBN already exists in the library.\n
             Make sure that the book you are trying to add has correct ISBN number.\n");
        }
    }

    my $coder = JSON->new->utf8;

    $coder->allow_blessed();
    my $book_instance = $_[1];
    sub TO_JSON {return { %{shift()} };}
    unbless($book_instance);

    eval {
        #JSON file stores a list of hashes, not a list of objects??
        #that's why I unbless the book instance => it makes it a regular hash NOW, not a Book=HASH
        #it adds a null object if i don't unbless it!!
        # необходимо е да се запазват като hash обекти в базата, понеже JSON не ги разпознава като обекти от тип книга и ги запазва като null (ако е без unbless)

        my $perl_list_of_books = json_file_to_perl('Database.json');
        push @$perl_list_of_books, $book_instance;

        my $updated_database = $coder->encode($perl_list_of_books);
        #todo: what if the program breaks here
        open my $fh, ">", "Database.json";
        print $fh ($updated_database);
        close($fh);
        $add_book_status = 1;

    } or eval {

        # output is the first Database entry in this case. The Database was completely empty before the operation
        my $output = $coder->encode($book_instance);
        open my $fh, ">", "Database.json";todo: #what if the program breaks here
        print($fh "[");
        print $fh ($output);
        print($fh "]");
        close($fh);
        $add_book_status = 1;
    }
    or eval{
        return(Status->new(0, "Cannot open the file!"))
    };
    return Status->new(1, "Book successfully added to the library!\n");
}

# КОДЪТ НАДОЛУ НЕ Е ПРЕРАБОТВАН!

sub find_book {
    my $book_to_return;
    my @search_criteria = $_[1];
    my $indicator = $search_criteria[0][0];
    my $value = $search_criteria[0][1];

    my $decoded = get_books();

    my @books_list = $decoded;
    foreach my $vals (@books_list) {
        foreach my $val (@$vals) {
            if (index($val->{$indicator}, $value) != -1) {
                $book_to_return = $val;
            }
        }
    }
    return ($book_to_return);
}

sub edit_book {
    my $book_to_return;
    my $indicator = $_[1];
    my $value = $_[2];

    my $decoded = get_books();

    my @books_list = $decoded;
    foreach my $vals (@books_list) {
        foreach my $val (@$vals) {
            if ($val->{$indicator} eq ($value)) {
                $book_to_return = $val;

            }
        }
    }
    return ($book_to_return);
}


sub delete_book() {
    my $is_found = "False";
    my $delete_isbn = "";
    my $del_counter = -1;
    my @search_criteria = $_[1];
    my $indicator = $search_criteria[0][0];
    my $value = $search_criteria[0][1];

    my $decoded = get_books();
    foreach my $vals (@$decoded) {
        $del_counter += 1;
        if (!defined($indicator)) {
            $is_found = "False";
            last;
        }
        if ($vals->{$indicator} eq $value) {
            $delete_isbn = $value;
            $is_found = "True";
            delete(@$decoded[$del_counter]);
            @$decoded = grep {defined && m/[^\s]/} @$decoded;
            last;

        }
    }
    my $JSON = JSON->new->utf8;
    $JSON->convert_blessed(4);

    my $commit_json = $JSON->encode($decoded);

    open my $final_in, '<', 'Database.json' or die "Can't read old file: $!";
    open my $final_out, '>', 'Database.json' or die "Can't read old file: $!";

    print $final_out $commit_json;

    while (<$final_in>) {
        s/\b(perl)\b/Perl/g;
        print $final_out $_;
    }
    close $final_out;
    my %book_details = (is_found => $is_found, ISBN => $delete_isbn);
    return (%book_details);
}

1;
