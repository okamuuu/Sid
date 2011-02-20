package Sid::Xslate;
use strict;
use warnings;
use Carp (); 
use Encode ();
use Text::Xslate qw/html_builder/;
use Smart::Args;
use MouseX::Types::Path::Class;

sub new {
    args my $class,
      my $template_file =>
      { isa => 'Path::Class::File', required => 1, coerce => 1 };

    ### I want to write like this.
    ### opts::coerce 'ExistsFile' => 'Str' => sub {..};
    Carp::croak( "NOT EXISTS the file: " . $template_file )
      if not $template_file->stat;

    return bless {
        tx => Text::Xslate->new(
            syntax   => 'Kolon',
            function => {
                html_unescape => html_builder { Encode::decode_utf8(shift) }, # :(
            },
        ),
        template_file => $template_file,
    }, $class;
}

sub render {
    my $self = shift;
    my %args = @_ == 1 ? %{ $_[0] } : @_; 
 
    return $self->{tx}->render($self->{template_file}->relative, {%args});
}

1;

