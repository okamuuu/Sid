#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

BEGIN { use_ok('Sid::Runner'); }
    
subtest 'Creating Sid::Config from config_file.' => sub {

    local @ARGV = qw( --config_file=t/samples/Doc-Markdown-Syntax/config.pl );

    my $config = Sid::Runner->_create_config;
    isa_ok( $config, 'Sid::Config' );
};

subtest 'run' => sub {
    local @ARGV = qw( --config_file=t/samples/Doc-Markdown-Syntax/config.pl );
    Sid::Runner->write_doc();
    pass();
};

done_testing();

