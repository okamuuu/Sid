package t::Utils;
use strict;
use warnings;
use Sid::Config;

sub config {
    Sid::Config->new(
        name          => 'project name',
        author        => 'your name',
        version       => '0.01',
        description   => 'this is document',
        template_file => 't/samples/Doc-Markdown-Syntax/template/layout.tx',
        doc_dir       => 't/samples/Doc-Markdown-Syntax/doc',
        html_dir      => 't/samples/Doc-Markdown-Syntax/html',
        readme_file   => 't/samples/Doc-Markdown-Syntax/Readme.md',
    ); 
}

1;

