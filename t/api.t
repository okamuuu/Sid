#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

BEGIN { use_ok('Sid::Api'); }

subtest 'generate html' => sub {

    my $api = Sid::Api->new(
        name          => 'Markdown-Syntax',
        readme        => 't/samples/Doc-Markdown-Syntax/doc/Readme.md',
        doc_dir       => 't/samples/Doc-Markdown-Syntax/doc',
        html_dir      => 't/samples/Doc-Markdown-Syntax/html',
        template_file => 't/samples/Doc-Markdown-Syntax/template/layout.tx',
    );

    $api->gen_html;
    pass();
};

done_testing();

