# Model

use strict;
use warnings;
package Library;
binmode STDOUT, ":utf8";
use JSON;
use Try::Tiny;
use JSON::Parse 'json_file_to_perl';
use Data::Structure::Util qw(unbless);

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
}

sub create_database {
    open(FileHandle, '>>C:\Users\Bobi\Documents\Desktop\Perl Scripts\Object Oriented Library Project - Perl Objects - Latest\Database.json');
    close FileHandle;
}

sub check_for_database {
    my $filename = 'C:\Users\Bobi\Documents\Desktop\Perl Scripts\Object Oriented Library Project - Perl Objects - Latest\Database.json';
    if (-e $filename) {
        return(0)
    }
    return(1)
}

sub load_library_as_hash {
    # do we really need a subroutine for that?
    my $json;
    {
        open(my $fh, 'Database.json') or die("can't open Database.json\n");
        local $/;
        $json = <$fh>;
        close $fh;
    }
    my $decoded = decode_json($json);
    return ($decoded)

}

sub library_to_book_objects($) {
    my @books_array;

    my @objects_array = load_library_as_hash();
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

sub check_book_duplicate($) {
    my $new_book = $_[1];
    my $lib = load_library_as_hash();
    my @books = library_to_book_objects($lib);
    my $is_duplicate = undef;

    foreach my $current_book (@books) {
        if ($current_book->{'ISBN'} eq $new_book->{'ISBN'}){
            $is_duplicate = 1;
            last;
        }
    }
    return($is_duplicate);

}


sub add_book() {
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
        open my $fh, ">", "Database.json";
        print $fh ($updated_database);
        close($fh);

    } or eval {

        # output is the first Database entry in this case. The Database was completely empty before the operation
        my $output = $coder->encode($book_instance);
        open my $fh, ">", "Database.json";
        print($fh "[");
        print $fh ($output);
        print($fh "]");
        close($fh);
    }
}

# КОДЪТ НАДОЛУ НЕ Е ВАЖЕН И НЕ Е ПРЕРАБОТВАН!

sub find_book {
    my $book_to_return;
    my @search_criteria = $_[1];
    my $indicator = $search_criteria[0][0];
    my $value = $search_criteria[0][1];

    my $decoded = load_library_as_hash();

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

    my $decoded = load_library_as_hash();

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

    my $decoded = load_library_as_hash();
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
