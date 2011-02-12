package Sid::Logic;
use strict;
use warnings;
use Sid::Model::Doc;
use Sid::Model::Category;
use Sid::Model::Article;
use Smart::Args qw/args/;
use HTML::TreeBuilder::XPath;
use Path::Class ();
use Carp ();
use Cwd ();

my $XPATH;
my $PARSER;

sub set_parser {
    my ($class, $parser) = @_;
    $PARSER = $parser;
}

sub create_doc {
    args my $class , my $config => { isa => 'Sid::Config', requied => 1 };

    my $categories_ref = [
        $class->_create_readme_as_category($config->readme_file),
        map    { $class->_create_category($_) }
          sort { $a cmp $b }
          grep { $_->is_dir and $_->basename =~ m/^\d+\-/ } $config->doc_dir->children
    ];

    return Sid::Model::Doc->new(
        name           => $config->name,
        author         => $config->author,
        version        => $config->version,
        description    => $config->descrpition,
        categories_ref => $categories_ref,
    );

}

sub _create_readme_as_category {
    my ( $class, $file ) = @_;

    return Sid::Model::Category->new(
        id           => 'readme',
        name         => 'README',
        articles_ref => [ $class->_create_article($file) ],
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

    my $xhtml = $PARSER->parse( scalar $file->slurp );

    $XPATH = HTML::TreeBuilder::XPath->new unless $XPATH;
    $XPATH->parse($xhtml);

    my $heading = $XPATH->findnodes('//h1')->get_node->as_text;

    my %seen;
    my $keywords_ref =
      [ grep { not $seen{$_}++ }
          map { $_->as_text } $XPATH->findnodes('//em')->get_nodelist ];

    return Sid::Model::Article->new(
        id           => $id,
        heading      => $heading,
        keywords_ref => $keywords_ref,
        content      => $xhtml,
    );  
}

1;

