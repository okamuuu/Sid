#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

BEGIN { use_ok('Sid::Runner'); }
    
my $runner = Sid::Runner->new;
isa_ok($runner, 'Sid::Runner');

subtest 'Creating Sid::Config from config_file.' => sub {

    local @ARGV = qw( --config_file=t/samples/Doc-Markdown-Syntax/config.pl );

    $runner->_create_config;
    isa_ok( $runner->config, 'Sid::Config' );
};

subtest 'Creating Sid::Model::Doc' => sub {
    $runner->_create_doc();
    isa_ok( $runner->doc, 'Sid::Model::Doc' );
};

subtest 'Writing html file..' => sub {
    $runner->_write_html();
    pass();
};

subtest 'run' => sub {
    local @ARGV = qw( --config_file=t/samples/Doc-Markdown-Syntax/config.pl );
    $runner->run();
    pass();
};

done_testing();

