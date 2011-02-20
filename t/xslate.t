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

done_testing();

