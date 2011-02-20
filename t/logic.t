#!/usr/bin/env perl
use strict;
use warnings;
use t::Utils;
use Test::More;

BEGIN { use_ok("Sid::Logic"); }

subtest 'create doc' => sub {

    my $config = t::Utils->config;
    isa_ok($config, "Sid::Config");

    my $doc = Sid::Logic->new( config => $config )->create_doc;
   
    isa_ok( $doc, "Sid::Model::Doc" ); 
};

done_testing();

