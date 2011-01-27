package Sid::Runner;
use strict;
use warnings;
use Sid::Extract;
use Sid::Model::Doc;
use Sid::Model::Category;
use Sid::Model::Archive;
use Sid::Plugin::Parser::Markdown;
use Sid::Plugin::View::TX;
use Cwd ();
use Path::Class ();
use Class::Accessor::Lite 0.05 (
    ro => [qw/name author version doc_dir html_dir template parser view/] );

sub new {
    my ($class, %args) = @_;

    my $name     = $args{name}          || 'My Project';
    my $author   = $args{author}        || 'cool guy';
    my $version  = $args{version}       || '0.01';
    my $doc      = $args{doc_dir}       || 'doc';
    my $html     = $args{html_dir}      || 'html';
    my $template = $args{template_file} || 'template/layout.tx';

    my $doc_dir  = Path::Class::Dir->new( Cwd::cwd(), $doc );
    my $html_dir = Path::Class::Dir->new( Cwd::cwd(), $html );
    my $template_file = Path::Class::File->new( Cwd::cwd, $template );
    
    my $view = Sid::Plugin::View::TX->new(template_file=>$template_file);
    my $parser = Sid::Plugin::Parser::Markdown->new;

    return bless {
        name     => $name,
        author   => $author,
        version  => $version,
        doc_dir  => $doc_dir,
        html_dir => $html_dir,
        view     => $view,
        parser   => $parser,
    }, $class;
}

sub gen_htmls {
    my $self = shift;

    my $doc = $self->create_doc;

    for my $archive ( map { $_->archives } $doc->categories ) {
        my $html = $self->view->render(
            doc            => $doc,
            categories_ref => $doc->categories_ref,
            archive        => $archive,
        );
        
        $self->gen_file( $archive->basename, \$html );
    }
}

sub gen_file {
    my ( $self, $basename, $html_ref ) = @_;

    my $encoded_html = Encode::encode_utf8($$html_ref);
    Path::Class::File->new( $self->html_dir->stringify, $basename )->openw->print($encoded_html); 
}

sub create_doc {
    my $self = shift;

    my @categories =
      map { $self->create_category($_) } $self->_get_category_dirs();

    return Sid::Model::Doc->new(
        name           => $self->name,
        author         => $self->author,
        version        => $self->version,
        categories_ref => [@categories],
    );
}

sub create_category {
    my ( $self, $dir ) = @_;

    $dir->basename =~ m/^(\d+)\-(.*)/ or return;

    my ( $id, $name ) = ( $1, $2 );

    my @archives =
      map { $self->create_archive($_) } _get_archive_files_in($dir);

    return Sid::Model::Category->new(
        id           => $id,
        name         => $name,
        archives_ref => [@archives],
    );
}

sub create_archive {
    my ( $self, $file ) = @_;

    $file->basename =~ m/^(\d+)\-(.*)\.txt/ or return;

    my ( $id, $name ) = ( $1, $2 );

    my $xhtml = $self->parser->parse( scalar $file->slurp );

    my $metadata = Sid::Extract->metadata_from($xhtml);

    return Sid::Model::Archive->new(
        id           => $id,
        cid          => 'hoge', 
        name         => $name,
        title        => $metadata->{title},
        keywords_ref => $metadata->{keywords_ref},
        description  => $metadata->{description},
        content      => $xhtml,
    );
}

sub _get_category_dirs {
    return sort { $a cmp $b }
      grep { $_->is_dir and $_->basename =~ m/^\d+\-/ }
      $_[0]->doc_dir->children;
}
   
sub _get_archive_files_in {
    my $dir = shift;
    sort { $a cmp $b }
      grep { not $_->is_dir and $_->basename =~ m/^\d+\-/ }
      $dir->children;
}   

1;

