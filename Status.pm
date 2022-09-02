# View

package Status;
use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
}

sub successful_operation {
    print("Book successfully added to the library!\n");
}

sub cancelled_operation {
    print("Operation cancelled - Did not add the book to the library!\n");
}
sub book_duplicate($) {
    my $ISBN = $_[0];
    print("Book with ISBN $ISBN already added to the library\n");
}

1;
