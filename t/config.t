#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

BEGIN { 
    use_ok("Sid::Config"); 
    use_ok("Sid::Plugin::Parser::Markdown"); 
    use_ok("Sid::Plugin::Renderer::TX"); 
}

subtest 'coerce' => sub {

    my $parser   = Sid::Plugin::Parser::Markdown->new;
    my $renderer = Sid::Plugin::Renderer::TX->new(
        template_file => Path::Class::File->new(
            't/samples/Doc-Markdown-Syntax/template/layout.tx')
    );

    my $config = Sid::Config->new(
        name        => 'project name',
        author      => 'your name',
        version     => '0.01',
        parser      => $parser,
        renderer    => $renderer,
        doc_dir     => 't/samples/Doc-Markdown-Syntax/doc',
        html_dir    => 't/samples/Doc-Markdown-Syntax/html',
        readme_file => 't/samples/Doc-Markdown-Syntax/Readme.md',
    );

    isa_ok( $config,              'Sid::Config' );
    isa_ok( $config->doc_dir,     'Path::Class::Dir' );
    isa_ok( $config->html_dir,    'Path::Class::Dir' );
    isa_ok( $config->readme_file, 'Path::Class::File' );
};

done_testing();

