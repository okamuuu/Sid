package Sid::Parser::Markdown;
use strict;
use warnings;
use Text::Markdown;

sub parse {
    my ($class, $text) = @_;

    Text::Markdown->new( tab_width => 4 )->markdown( $text );
}

1;

