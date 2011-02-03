#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Differences;
use Path::Class ();

BEGIN { use_ok("Sid::Plugin::View::TX"); }

my $view = Sid::Plugin::View::TX->new( template_file => Path::Class::File->new('t/samples/Doc-Markdown-Syntax/template/name.tx') );

isa_ok( $view, 'Sid::Plugin::View::TX' );
can_ok( $view, 'render');

my $html = $view->render(name=>'Mike');

chomp $html;
is $html, 'Hello, Mike!';


done_testing();

