package Sid::Config;
use strict;
use warnings;
use Smart::Args;
use MouseX::Types::Path::Class;
use Class::Accessor::Lite 0.05 (
    ro  => [qw/name author version parser renderer readme_file doc_dir html_dir/],
);

sub new {
    args my $class, 
      my $name => { isa => 'Str', required => 1 },
      my $author   => { isa => 'Str', required => 1 },
      my $version  => { isa => 'Str', required => 1 },
      my $parser => { isa => 'Sid::Plugin::Parser', required=> 1 },
      my $renderer => { isa => 'Sid::Plugin::Renderer', required=> 1 },
      my $doc_dir  => { isa => 'Path::Class::Dir', required => 1, coerce => 1 },
      my $html_dir => { isa => 'Path::Class::Dir', required => 1, coerce => 1 },
      my $readme_file =>
      { isa => 'Path::Class::File', required => 1, coerce => 1 },
      ;

    return bless {
        name        => $name,
        author      => $author,
        version     => $version,
        readme_file => $readme_file,
        doc_dir     => $doc_dir,
        html_dir    => $html_dir,
    }, $class;
}

1;

