package Sid::Runner;
use strict;
use warnings;
use Sid::Config;
use Sid::Api;
use Path::Class ();
use opts;

opts::coerce 'ExistsFile' => 'Str' => sub { 
    my $file = Path::Class::File->new($_[0]);
    Carp::croak("NOT EXISTS the file: " . $_[0]) if not $file->stat;
    return $file;
 };

sub write_doc {
    my $class = shift;
    my $config = $class->_create_config();
    Sid::Api->new( config => $config )->write_doc;
}

sub _create_config {
    opts my $class, 
        my $config_file => { isa => 'ExistsFile', required => 1, default => 'config.pl' };

    my $config = do $config_file->stringify
      or Carp::croak "please write config";

    return Sid::Config->new($config);
}

1;

