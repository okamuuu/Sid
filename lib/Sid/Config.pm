package Sid::Config;
use strict;
use warnings;
use Sid::Xslate;
use Smart::Args;
use MouseX::Types::Path::Class;
use Class::Accessor::Lite 0.05 (
    ro  => [qw/name author version descrpition xslate readme_file doc_dir html_dir/],
);

sub new {
    args my $class, my $name => { isa => 'Str', required => 1 },
      my $author      => { isa => 'Str',     required => 1 },
      my $version     => { isa => 'Str',     required => 1 },
      my $description => { isa => 'Str',     required => 1 },

      my $doc_dir => {
        isa      => 'Path::Class::Dir',
        required => 1,
        coerce   => 1,
        default  => 'doc'
      },
      my $html_dir => {
        isa      => 'Path::Class::Dir',
        required => 1,
        coerce   => 1,
        default  => 'html'
      },
      my $readme_file => {
        isa      => 'Path::Class::File',
        required => 1,
        coerce   => 1,
        default  => 'Readme.md'
      },
      my $template_file => {
        isa      => 'Path::Class::File',
        required => 1,
        coerce   => 1,
      },
      ;

    my $xslate = Sid::Xslate->new( template_file => $template_file );

    return bless {
        name        => $name,
        author      => $author,
        version     => $version,
        descrpition => $description,
        readme_file => $readme_file,
        doc_dir     => $doc_dir,
        html_dir    => $html_dir,
        xslate      => $xslate,
    }, $class;
}

1;

