package Sid::Model::Article;
use Class::Accessor::Lite 0.05 (
    new => 1,
    ro  => [qw/id heading keywords_ref content/]
);

sub keywords { @{ $_[0]->{keywords_ref} } }

1;
