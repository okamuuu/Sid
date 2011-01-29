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
    my $template_file = Path::Class::File->new( Cwd::cwd(), $template );

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

sub rmtree_category_dirs {
    $_->rmtree
      for grep { $_->basename =~ m/^\d+\-/ } $_[0]->html_dir->children;
}

sub mkpath_category_dirs {
    $_->mkpath
      for map { $_[0]->html_dir->subdir( $_->basename ) }
      grep { $_->basename =~ m/^\d+\-/ } $_[0]->doc_dir->children;
}

sub run {
    my $self = shift;

    $self->rmtree_category_dirs;
    $self->mkpath_category_dirs;

    my $doc = $self->create_doc;

    for my $archive ( map { $_->archives } $doc->categories ) {

        my $html = $self->view->render(
            doc            => $doc,
            categories_ref => $doc->categories_ref,
            archive        => $archive,
        );

        my $encoded_html = Encode::encode_utf8($html);
        $archive->file->openw->print($encoded_html);
    }
}

sub create_doc {
    my $self = shift;

    my $categories_ref = [
        map    { $self->create_category($_) }
          sort { $a cmp $b }
          grep { $_->is_dir and $_->basename =~ m/^\d+\-/ }
          $self->doc_dir->children
    ];

    return Sid::Model::Doc->new(
        name           => $self->name,
        author         => $self->author,
        version        => $self->version,
        categories_ref => $categories_ref,
    );
}

sub create_category {
    my ( $self, $dir ) = @_;

    $dir->basename =~ m/^\d+\-(.*)/ or return;
    
    my $archives_ref = [ map { $self->create_archive($_) }
      sort { $a cmp $b }
      grep { not $_->is_dir and $_->basename =~ m/^\d+\-/ } $dir->children ];

    return Sid::Model::Category->new(
        name         => $dir->basename,
        archives_ref => $archives_ref,
    );
}

sub create_archive {
    my ( $self, $file ) = @_;

    $file->basename =~ m/^(\d+\-.*)\.(?:txt|md|mkdn)/ or return;
    my $name = $1;

    my $xhtml = $self->parser->parse( scalar $file->slurp );

    my $metadata = Sid::Extract->metadata_from($xhtml);
   
    my $renamed_file =
      Path::Class::File->new( $self->html_dir, $file->parent->basename,
        "$name.html" );
    
    $renamed_file->touch;

    return Sid::Model::Archive->new(
        file         => $renamed_file,
        title        => $metadata->{title},
        keywords_ref => $metadata->{keywords_ref},
        description  => $metadata->{description},
        content      => $xhtml,
    );
}

1;

