package Sid::Logic;
use strict;
use warnings;
use Sid::Model::Doc;
use Sid::Model::Category;
use Sid::Model::Article;
use HTML::TreeBuilder::XPath;
use Path::Class ();
use Carp ();
use Cwd ();

my ($XPATH, $PARSER);

sub to_path_class_file {
    my ($class, @path ) = @_;
    return Path::Class::File->new( Cwd::cwd(), @path );
}

sub to_path_class_dir {
    my ($class, @path ) = @_;
    return Path::Class::Dir->new( Cwd::cwd(), @path );
}

sub set_parser {
    my ($class, $parser) = @_;
    $PARSER = $parser;
}

sub create_doc {
    my ($class, $dir) = @_;

    Carp::croak unless $PARSER;

    my $categories_ref = [
        map    { $class->_create_category($_) }
          sort { $a cmp $b }
          grep { $_->is_dir and $_->basename =~ m/^\d+\-/ }
          $dir->children
    ];

    return Sid::Model::Doc->new(
        categories_ref => $categories_ref,
    );
}

sub _create_category {
    my ( $class, $dir ) = @_;

    $dir->basename =~ m/^(\d+)\-(.*)/ or return;
    my ( $id, $name ) = ($1, $2);

    my $articles_ref = [ map { $class->_create_article($_) }
      sort { $a cmp $b }
      grep { not $_->is_dir and $_->basename =~ m/^\d+\-/ } $dir->children ];

    return Sid::Model::Category->new(
        id           => $id,
        name         => $name,
        articles_ref => $articles_ref,
    );
}

sub _create_article {
    my ( $class, $file ) = @_; 

    $file->basename =~ m/^(\d+)\-(.*)\.txt/ or return;

    my ( $id, $name ) = ($1, $2);  

    my $xhtml = $PARSER->parse( scalar $file->slurp );

    $XPATH = HTML::TreeBuilder::XPath->new unless $XPATH;
    $XPATH->parse($xhtml);

    my $heading = $XPATH->findnodes('//h1')->get_node->as_text;

    my %seen;
    my $keywords_ref =
      [ grep { not $seen{$_}++ }
          map { $_->as_text } $XPATH->findnodes('//em')->get_nodelist ];

    return Sid::Model::Article->new(
        id           => $file->basename,
        heading      => $heading,
        keywords_ref => $keywords_ref,
        content      => $xhtml,
    );  
}

1;

