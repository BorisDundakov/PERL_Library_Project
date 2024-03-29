use strict;
use warnings;

# sub load_library_as_hash {
#     # do we really need a subroutine for that?
#     my $json;
#     {
#         open(my $fh, 'Database.json') or die("can't open Database.json\n");
#         local $/;
#         $json = <$fh>;
#         close $fh;
#     }
#     my $decoded = decode_json($json);
#     return ($decoded)
#
# }


sub library_to_book_objects($) {
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
