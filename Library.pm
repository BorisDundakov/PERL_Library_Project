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

    }
    else {
        create_database();
    }
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

sub check_book_duplicate($) {
    my $is_duplicate = "False";
    my $book_instance = $_[1];

    try {
        my $perl_list_of_books = json_file_to_perl('Database.json');

        #TODO-> perl_list_of_books = {REF TO ARRAY}; it should be "{REF TO ARRAY OF BOOKS??}"
        foreach my $current_book (@$perl_list_of_books) {
            my $book = Book->new();
            # няма как да се свалят книгите и директно да са обекти от тип Book=Hash.
            # ако книгите се качват в базата като обекти от тип Book=Hash, то JSON ги запазва като null;
            #book -> Book = {HASH}
            #working with perl Objects instead of just hashes
            $book->set_ISBN($current_book->{'ISBN'});
            if($book->{'ISBN'} eq $book_instance->{'ISBN'}) {
                $is_duplicate = "True";
            }
        }
        # VARIANT 2
        # perl_list_of_books = {REF TO ARRAY};
        # current_book -> {HASH}
        foreach my $current_book (@$perl_list_of_books) {
            if($current_book->{'ISBN'} eq $book_instance->{'ISBN'}) {
                $is_duplicate = "True";
            }
        }


        my %book_details = (is_duplicate => $is_duplicate, ISBN => $book_instance->{'ISBN'});
        return (%book_details);
    };
    my % book_details = (is_duplicate => $is_duplicate, ISBN => $book_instance->{'ISBN'});
    return (%book_details);

}





sub add_book() {
    my $coder = JSON->new->utf8;

    $coder->allow_blessed();
    my $book_instance = $_[1];
    sub TO_JSON {return { %{shift()} };}
    unbless($book_instance);

    eval{
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

    } or eval{

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
