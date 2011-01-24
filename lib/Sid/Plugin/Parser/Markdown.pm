package Sid::Plugin::Parser::Markdown;
use strict;
use warnings;
use Text::Markdown;

sub new {
    my $class = shift;
    return bless { parser => Text::Markdown->new( tab_width => 4 ) }, $class;
}

sub parse {
    my ($self, $text) = @_;

    $self->{parser}->markdown( $text );
}

1;

