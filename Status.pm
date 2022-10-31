# View

package Status;
use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = {
        _status  => shift,
        _message => shift,
        # message is optional argument?
    };
    bless $self, $class;
    return $self;
}

sub successful_operation {
    my $self = shift;
    $self->{'_message'} = "Book successfully added to the library!\n";
    return("Book successfully added to the library!\n");
}

sub IO_error{
    my $self = shift;
    $self->{'_status'} = 0; # maybe status should not be set from here at all!
    $self->{'_message'} = "Could not store the library: Permission denied"
}

sub cancelled_operation {
    return("Operation cancelled - Did not add the book to the library!\n");
}
sub book_duplicate($) {
    my $ISBN = $_[1];
    return("Book with ISBN $ISBN already added to the library\n");
}
# status has 1 get message method and that's it?
sub get_message{
    my $self = shift;
    return($self->{'_message'});
}

1;
