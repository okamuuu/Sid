#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

BEGIN { use_ok('Sid::Runner'); }

subtest 'samples Doc-Markdown-Syntax' => sub {
    my $doc = Sid::Runner->new( name => 'Markdown::Syntax', doc_dir => 't/samples/Doc-Markdown-Syntax' )->create_doc;
    isa_ok($doc, "Sid::Model::Doc");

    is $doc->name, 'Markdown::Syntax';
    is $doc->author, 'cool guy';
    is $doc->version, '0.01';
    isa_ok($_, "Sid::Model::Category") for @{ $doc->categories };
     
};

done_testing();

