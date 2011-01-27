#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Path::Class ();

BEGIN { use_ok('Sid::Runner'); }

subtest 'samples Doc-Markdown-Syntax' => sub {

    my $runner = Sid::Runner->new(
        name          => 'Markdown-Syntax',
        doc_dir       => 't/samples/Doc-Markdown-Syntax/doc',
        html_dir      => 't/samples/Doc-Markdown-Syntax/html',
        template_file => Path::Class::File->new('t/samples/Doc-Markdown-Syntax/template/layout.tx'),
    );

    subtest 'create document' => sub {
        my $doc = $runner->create_doc;

        isa_ok( $doc, "Sid::Model::Doc" );
        is $doc->name,    'Markdown-Syntax';
        is $doc->author,  'cool guy';
        is $doc->version, '0.01';
        isa_ok( $_, "Sid::Model::Category" ) for $doc->categories;
    };

    subtest 'gen_htmls' => sub {
        $runner->gen_htmls;     
        pass();
    };

};

done_testing();

