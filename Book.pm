# Model

use strict;
use warnings;

package Book;

sub new {
    my $class = shift;
    my $self = {
        author           => shift,
        title            => shift,
        publication_date => shift,
        n_pages          => shift,
        ISBN             => shift,
    };
    bless $self, $class;
    return ($self);

}

#validators ( getters and setters)

sub get_author{
    my( $self ) = @_;
    return($self->{author});
}

sub set_author{
    my($self, $author) = @_;
    my $author_validation = $author =~ /^(?!\s*$).+/;
    $self->{author} = $author if (($author_validation) eq! "");
    return($self->{author});
}

sub get_title{
    my( $self ) = @_;
    return($self->{title});
}

sub set_title{
    my($self, $title) = @_;
    my $title_validation = $title =~/^(?!\s*$).+/;
    $self->{title} = $title if (($title_validation) eq! "");
    return($self->{title});
}

sub get_publication_date{
    my( $self ) = @_;
    return($self->{publication_date});
}

sub set_publication_date{
    my($self, $publication_date) = @_;
    my $date_validation = $publication_date =~ /^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$/;
    $self->{publication_date} = $publication_date if($date_validation eq! "");
    return($self->{publication_date});
}

sub get_n_pages{
    my( $self ) = @_;
    return($self->{n_pages});
}

sub set_n_pages{
    my($self, $pages) = @_;
    my $pages_validation = $pages =~ /^[0-9]+$/;
    $self->{n_pages} = $pages if($pages_validation eq! "");
    return($self->{n_pages});
}

sub get_ISBN{
    my( $self ) = @_;
    return($self->{ISBN});
}

sub set_ISBN{
    my($self, $ISBN) = @_;
    my $isbn_validation = $ISBN =~ /^(?=(?:\D*\d){10}(?:(?:\D*\d){3})?$)[\d-]+$/;
    $self->{ISBN} = $ISBN if ($isbn_validation eq! "");
    return($self->{ISBN});
}


1;
