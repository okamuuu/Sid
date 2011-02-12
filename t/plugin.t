#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Differences;
use Path::Class ();

BEGIN { use_ok("Sid::Plugin::Renderer::TX"); }

subtest 'argument is string' => sub {
    my $view = Sid::Plugin::Renderer::TX->new(
        template_file => 't/samples/Doc-Markdown-Syntax/template/name.tx');

    isa_ok( $view, 'Sid::Plugin::Renderer::TX' );
    can_ok( $view, 'render' );
    
    my $html = $view->render(name=>'Mike');

    chomp $html;
    is $html, 'Hello, Mike!';
};

subtest 'argument is Path::Class::File' => sub {
    my $view = Sid::Plugin::Renderer::TX->new(
        template_file => Path::Class::File->new(
            't/samples/Doc-Markdown-Syntax/template/name.tx')
    );

    isa_ok( $view, 'Sid::Plugin::Renderer::TX' );
};



done_testing();

