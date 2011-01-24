package Sid::Model::Category;
use strict;
use warnings;
use Carp ();

sub new {
    my ( $class, $dir ) = @_;

    Carp::croak('This is NOT Path::Class::Dir...')
      unless $dir->isa('Path::Class::Dir');

    $dir->basename =~ m/^(\d+)\-(.*)$/
      or Carp::croak('This is NOT MATCH Category...');

    my ( $id, $name ) = $1, $2;

    my @archives = sort { $a cmp $b }
      grep { $_->is_dir and $_->basename =~ m/^\d+\-/ } $dir->children;

    return bless {
        id   => $id,
        name => $name,
        archives => [@archives],  
    }, $class;
}

sub archives { $_[0]->{archives} }

1;

