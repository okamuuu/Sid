package Sid::Model::Archive;
use strict;
use warnings;
use Class::Accessor::Lite 0.05 (
    new => 1,
    ro  => [qw/id cid name title keywords_ref description content/],
);

sub keywords { @{ $_[0]->{keywords_ref} } }

sub joined_keywords { join ', ', $_[0]->keywords }

sub basename { $_[0]->cid . '-' . $_[0]->id . '-' . $_[0]->name . ".html" } 

1;

