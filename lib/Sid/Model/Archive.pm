package Sid::Model::Archive;
use strict;
use warnings;
use Class::Accessor::Lite 0.05 (
    new => 1,
    ro  => [qw/id basename title keywords description content/],
);

1;

