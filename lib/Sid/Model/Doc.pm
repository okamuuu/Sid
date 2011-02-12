package Sid::Model::Doc;
use strict;
use warnings;
use Class::Accessor::Lite 0.05 (
    new => 1,
    ro  => [qw/name description author version categories_ref/],
);

sub categories { @{ $_[0]->{categories_ref} } }

1;

