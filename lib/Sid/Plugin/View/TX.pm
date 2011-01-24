package Sid::Plugin::View::TX;
use strict;
use warnings;
use Carp ();
use Text::Xslate ();

sub new {
    my ( $class, %args ) = @_;

    my $template = $args{template}
      or Carp::croak("missing mandatory parameter 'template_file'...");

    return bless { tx => Text::Xslate->new, template => $template }, $class;
}

sub render {
    my $self = shift;
    my %args = @_ == 1 ? %{ $_[0] } : @_;
 
    return $self->{tx}->render($self->{template}, {%args});
}

1;

