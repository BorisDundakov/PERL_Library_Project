use strict;
use warnings;

package TestPackage;

sub new{
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
}

sub add{
    my ($self, $first_num, $second_num) = @_;
    my $result = $first_num + $second_num;
    return($result);

}

my $test = TestPackage->new();
my $res = $test->add(7,2);
print($res);