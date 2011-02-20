#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

BEGIN { 
    use_ok("Sid::Config"); 
}

subtest 'create instance' => sub {

    my $config = Sid::Config->new(
        name          => 'project name',
        author        => 'your name',
        version       => '0.01',
        description   => 'this is document',
        template_file => 't/samples/Doc-Markdown-Syntax/template/layout.tx',
        doc_dir       => 't/samples/Doc-Markdown-Syntax/doc',
        html_dir      => 't/samples/Doc-Markdown-Syntax/html',
        readme_file   => 't/samples/Doc-Markdown-Syntax/Readme.md',
    );

    isa_ok( $config,              'Sid::Config' );
    isa_ok( $config->xslate,      'Sid::Xslate' );
    isa_ok( $config->doc_dir,     'Path::Class::Dir' );
    isa_ok( $config->html_dir,    'Path::Class::Dir' );
    isa_ok( $config->readme_file, 'Path::Class::File' );
};

done_testing();

