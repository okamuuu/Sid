package Sid::Config;
use strict;
use warnings;
use Class::Load ();
use Smart::Args;
use MouseX::Types::Path::Class;
use Class::Accessor::Lite 0.05 (
    ro  => [qw/name author version descrpition parser renderer readme_file doc_dir html_dir/],
);

sub new {
    args my $class, my $name => { isa => 'Str', required => 1 },
      my $author      => { isa => 'Str',     required => 1 },
      my $version     => { isa => 'Str',     required => 1 },
      my $description => { isa => 'Str',     required => 1 },
      my $plugins     => { isa => 'HashRef', required => 1 },

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
      ;

    my $parser_name   = $plugins->{parser}->{name};
    my $renderer_name = $plugins->{renderer}->{name};

    Class::Load::load_class($parser_name);
    my $parser_class = $parser_name->new( $plugins->{parser}->{options} );

    Class::Load::load_class($renderer_name);
    my $renderer_class = $renderer_name->new( $plugins->{renderer}->{options} );

    return bless {
        name        => $name,
        author      => $author,
        version     => $version,
        descrpition => $description,
        readme_file => $readme_file,
        doc_dir     => $doc_dir,
        html_dir    => $html_dir,
        parser      => $parser_class,
        renderer    => $renderer_class,
    }, $class;
}

1;

