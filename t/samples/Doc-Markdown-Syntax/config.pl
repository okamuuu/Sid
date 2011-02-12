use utf8;
{
    name => 'Doc Markdown Syntax',
    author => 'cool guy',
    version => '0.01',
    description => 'This document is copied from http://daringfireball.net/projects/markdown/syntax',
    plugins => {
        parser => {
            name => 'Sid::Plugin::Parser::Markdown',
            options => {},
        },
        renderer => {
            name => 'Sid::Plugin::Renderer::TX',
            options => { template_file => 't/samples/Doc-Markdown-Syntax/template/layout.tx' },
        },
    },
    doc_dir     => 't/samples/Doc-Markdown-Syntax/doc',
    html_dir    => 't/samples/Doc-Markdown-Syntax/html',
    readme_file => 't/samples/Doc-Markdown-Syntax/Readme.md',
};

