use Plack::Builder;
use Plack::App::File;
use Sid::Runner;

local @ARGV = qw( --config_file=t/samples/Doc-Markdown-Syntax/config.pl );

Sid::Runner->new->run;

builder {
    enable 'Plack::Middleware::Static', path => qr{^/}, root => 't/samples/Doc-Markdown-Syntax/html/';
};


