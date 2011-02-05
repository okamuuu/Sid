package Sid::Model::Category;
use strict;
use warnings;
use Class::Accessor::Lite 0.05 (
    new => 1,
    ro  => [qw/id name articles_ref/],
);

sub articles { @{ $_[0]->{articles_ref} } }

sub joined_keywords { join ', ', map { $_->keywords } $_[0]->articles; }

sub basename {
    return $_[0]->id eq 'readme'
      ? 'index.html'
      : $_[0]->id . "-" . $_[0]->name . ".html";
}

1;

