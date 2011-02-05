package Sid::Plugin::View::TX;
use strict;
use warnings;
use Carp ();
use Text::Xslate ();

sub new {
    my ( $class, %args ) = @_;

    my $template_file = $args{template_file}
      or Carp::croak("missing mandatory parameter 'template_file'...");

    return bless {
        tx => Text::Xslate->new(
            syntax => 'Kolon',
            function => {
                html_unescape => sub {
                    Text::Xslate::mark_raw(shift);
                },
            },
        ),
        template => $template_file->relative
    }, $class;
}

sub render {
    my $self = shift;
    my %args = @_ == 1 ? %{ $_[0] } : @_;
 
    return $self->{tx}->render($self->{template}, {%args});
}

1;

