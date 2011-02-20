#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Exception;
use Path::Class::File;
use File::Temp ();

BEGIN { 
    use_ok('Sid::Api::Msg'); 
    use_ok('Sid::Api::DebugMsg'); 
    use_ok('Sid::Api::Base'); 
    use_ok('Sid::Api'); 
}

subtest 'msg' => sub {

    my $msg = Sid::Api::Msg->new;
    isa_ok($msg, "Sid::Api::Msg");
 
    is $msg->has_msgs, 0;
    
    lives_ok { $msg->set_msgs('you send a mail') };
    is $msg->has_msgs, 1;
    is_deeply [ $msg->get_msgs ], ['you send a mail'];
    
    lives_ok { $msg->set_msgs( 'you got a mail', 'you drop the mail' ) };
    is $msg->has_msgs, 3;
    is_deeply [ $msg->get_msgs ], ['you send a mail', 'you got a mail', 'you drop the mail'];
};

subtest 'DebugMsg' => sub {

    my $debug = Sid::Api::DebugMsg->new;
    isa_ok($debug, "Sid::Api::DebugMsg");
    
    lives_ok { $debug->set_msgs('you send a mail') };
    is $debug->has_msgs, 1;
    like [ $debug->get_msgs ]->[0], qr/\[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\] you send a mail \( [\.\d]+ sec \)/;
};

subtest 'Base' => sub {

    my $tmp_file = Path::Class::File->new( scalar File::Temp::tmpnam );

    my $base = Sid::Api::Base->new(log_path=>$tmp_file->stringify);
    isa_ok($base, "Sid::Api::Base");
    
    lives_ok { $base->set_debug_msgs('debug') };

    undef $base;
    my @lines = $tmp_file->slurp(chomp=>1);
    like $lines[1], qr/\[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\] debug \( [\.\d]+ sec \)/;
};

=pod

subtest 'generate html' => sub {

    my $api = Sid::Api->new(
        name          => 'Markdown-Syntax',
        readme        => 't/samples/Doc-Markdown-Syntax/Readme.md',
        doc_dir       => 't/samples/Doc-Markdown-Syntax/doc',
        html_dir      => 't/samples/Doc-Markdown-Syntax/html',
        template_file => 't/samples/Doc-Markdown-Syntax/template/layout.tx',
    );

    $api->gen_html;
    pass();
};
=cut

done_testing();

