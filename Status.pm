# View

package Status;
use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = {
        _success  => shift,
        _message => shift,
        # message is optional argument?
    };
    bless $self, $class;
    return $self;
}

sub get_message{
    my $self = shift;
    return($self->{'_message'});
}

sub is_successful{
    my $self = shift;
    return($self->{'_success'});
}
1;
