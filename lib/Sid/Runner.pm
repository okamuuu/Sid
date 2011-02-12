package Sid::Runner;
use strict;
use warnings;
use Sid::Config;
use Sid::Api;
use opts;
use Path::Class ();
use Smart::Args;
use Class::Accessor::Lite 0.05 (
    new => 1,
    rw  => [qw/config doc/],
);

opts::coerce 'ExistsFile' => 'Str' => sub { 
    my $file = Path::Class::File->new($_[0]);
    Carp::croak("NOT EXISTS the file: " . $_[0]) if not $file->stat;
    return $file;
 };

sub run {
    my $self = shift;
    $self->_create_config();
    $self->_create_doc();
    $self->_write_html();
}

sub _create_config {
    opts my $self, 
        my $config_file => { isa => 'ExistsFile', required => 1, default => 'config.pl' };

    my $config = do $config_file->stringify
      or Carp::croak "please write config";

    $self->config( Sid::Config->new($config) );
}

sub _create_doc {
    my $doc = Sid::Api->new( config => $_[0]->config )->create_doc;
    $_[0]->doc($doc);
}

sub _write_html {
    Sid::Api->new( config => $_[0]->config )->write_html( doc => $_[0]->doc );
}

1;

