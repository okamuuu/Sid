package Sid::Extract;
use strict;
use warnings;
use List::MoreUtils qw/uniq/;
use HTML::TreeBuilder::XPath;

my $xpath;

sub metadata_from {
    my ( $class, $xhtml ) = @_;

    $xpath = HTML::TreeBuilder::XPath->new unless $xpath;

    $xpath->parse($xhtml);

    my $title = $xpath->findnodes('//h1')->get_node->as_text;

    my @keywords =
      uniq map { $_->as_text } $xpath->findnodes('//em')->get_nodelist;

    my $description = $xpath->findnodes('//p')->reverse->get_node->as_text;

    return {
        title       => $title,
        keywords    => [@keywords],
        description => $description,
    };
}

1;

