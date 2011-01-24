package Sid::Model::Category;
use Class::Accessor::Lite 0.05 (
    new => 1,
    ro  => [qw/id name archives_ref/],
);

sub archives { @{ $_[0]->{archives_ref} } }

1;

