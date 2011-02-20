#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Differences;
use Path::Class ();

BEGIN { use_ok("Sid::Xslate"); }

subtest 'argument is string' => sub {
    my $xslate = Sid::Xslate->new(
        template_file => 't/samples/Doc-Markdown-Syntax/template/name.tx');

    isa_ok( $xslate, 'Sid::Xslate' );
    can_ok( $xslate, 'render' );
    
    my $html = $xslate->render(name=>'Mike');
    chomp $html;
    is $html, 'Hello, Mike!';
};

subtest 'parse markdown' => sub {
    my $xslate = Sid::Xslate->new(
        template_file => Path::Class::File->new(
            't/samples/Doc-Markdown-Syntax/template/markdown.tx')
    );

    isa_ok( $xslate, 'Sid::Xslate' );

    my $text = <<EOT;
test
====
EOT
    
    my $html = $xslate->render(text=>$text);
    chomp $html;
    chomp $html;
    is $html, '<h1>test</h1>';
};




done_testing();

