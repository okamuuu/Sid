package Sid::Api;
use strict;
use warnings;
use Sid::Logic;
use Sid::Plugin::Parser::Markdown;
use Sid::Plugin::View::TX;
use Encode ();
use Class::Accessor::Lite 0.05 (
    ro => [qw/name author version readme doc_dir html_dir template parser view/] );

sub new {
    my ($class, %args) = @_;

    my $name     = $args{name}          || 'My Project';
    my $author   = $args{author}        || 'cool guy';
    my $version  = $args{version}       || '0.01';
    my $readme   = $args{readme}        || 'readme';
    my $doc      = $args{doc_dir}       || 'doc';
    my $html     = $args{html_dir}      || 'html';
    my $template = $args{template_file} || 'template/layout.tx';

    my $readme_file   = Sid::Logic->to_path_class_file($readme);
    my $doc_dir       = Sid::Logic->to_path_class_dir($doc);
    my $html_dir      = Sid::Logic->to_path_class_dir($html);
    my $template_file = Sid::Logic->to_path_class_file($template);

    my $view = Sid::Plugin::View::TX->new(template_file=>$template_file);
    my $parser = Sid::Plugin::Parser::Markdown->new;

    Sid::Logic->set_parser($parser);

    return bless {
        name     => $name,
        author   => $author,
        version  => $version,
        readme   => $readme_file,
        doc_dir  => $doc_dir,
        html_dir => $html_dir,
        view     => $view,
        parser   => $parser,
    }, $class;
}

sub gen_html {
    my $self = shift;

    my $doc = Sid::Logic->create_doc(
        name    => $self->name,
        author  => $self->author,
        version => $self->version,
        readme  => $self->readme,
        doc_dir => $self->doc_dir,
    );

    for my $category ( $doc->categories ) {

        my $html = $self->view->render(
            doc      => $doc,
            current_cat_id => $category->id,
            category => $category,
        );

        my $encoded_html = Encode::encode_utf8($html);
        Path::Class::File->new( $self->html_dir, $category->basename )
          ->openw->print($encoded_html);
    }
}

1;

