package Sid::Model::Category;
use strict;
use warnings;
use Class::Accessor::Lite 0.05 (
    new => 1,
    ro  => [qw/id name articles_ref/],
);

sub articles { @{ $_[0]->{articles_ref} } }

1;

