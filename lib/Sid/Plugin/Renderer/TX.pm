package Sid::Plugin::Renderer::TX;
use strict;
use warnings;
use parent 'Sid::Plugin::Renderer';
use Carp ();
use Text::Xslate ();
use Smart::Args;
use MouseX::Types::Path::Class;

sub new {
    args my $class, my $template_file =>
      { isa => 'Path::Class::File', required => 1, coerce => 1 };

    return bless {
        tx => Text::Xslate->new(
            syntax   => 'Kolon',
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

