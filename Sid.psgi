use Plack::Builder;

builder {
    enable 'Plack::Middleware::Static', path => qr{^/}, root => 't/samples/Doc-Markdown-Syntax/html/';
};


