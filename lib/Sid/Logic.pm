package Sid::Logic;
use strict;
use warnings;
use Sid::Model::Doc;
use Sid::Model::Category;
use Sid::Model::Article;
use Smart::Args qw/args/;
use Text::Markdown ();
use HTML::TreeBuilder::XPath;
use Class::Accessor::Lite 0.05 (
    new => 1,
    ro  => [qw/config/],
    rw  => [qw/_xpath/],
);

sub xpath {
    my $self = shift;
    return $self->_xpath if $self->_xpath;
    return $self->_xpath( HTML::TreeBuilder::XPath->new );
}

sub create_doc {
    my $self = shift;

    my $categories_ref = [
        $self->_create_readme_as_category($self->config->readme_file),
        map    { $self->_create_category($_) }
          sort { $a cmp $b }
          grep { $_->is_dir and $_->basename =~ m/^\d+\-/ } $self->config->doc_dir->children
    ];

    return Sid::Model::Doc->new(
        name           => $self->config->name,
        author         => $self->config->author,
        version        => $self->config->version,
        description    => $self->config->descrpition,
        categories_ref => $categories_ref,
    );

}

sub _create_readme_as_category {
    my ( $self, $file ) = @_;

    return Sid::Model::Category->new(
        id           => 'readme',
        name         => 'README',
        articles_ref => [ $self->_create_article($file) ],
    );
}

sub _create_category {
    my ( $self, $dir ) = @_;

    $dir->basename =~ m/^(\d+)\-(.*)/ or return;
    my ( $id, $name ) = ($1, $2);

    my $articles_ref = [ map { $self->_create_article($_) }
      sort { $a cmp $b }
      grep { not $_->is_dir and $_->basename =~ m/^\d+\-/ } $dir->children ];

    return Sid::Model::Category->new(
        id           => $id,
        name         => $name,
        articles_ref => $articles_ref,
    );
}

sub _create_article {
    my ( $self, $file ) = @_; 

    my $id;

    ### XXX: readmeのファイル名が固定されている
    if ( $file->basename =~ m/^Readme/ ) {
        $id = 0;
    }
    elsif ( $file->basename =~ m/^(\d+)\-.*\.txt/ ) {
        $id = $1;
    }
    else {
        return;
    }

    my $xhtml = Text::Markdown::markdown( scalar $file->slurp );
    $self->xpath->parse($xhtml);

    my $heading = $self->xpath->findnodes('//h1')->get_node->as_text;

    my %seen;
    my $keywords_ref =
      [ grep { not $seen{$_}++ }
          map { $_->as_text } $self->xpath->findnodes('//em')->get_nodelist ];

    return Sid::Model::Article->new(
        id           => $id,
        heading      => $heading,
        keywords_ref => $keywords_ref,
        content      => $xhtml,
    );  
}

1;

