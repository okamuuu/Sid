package Sid::Api;
use strict;
use warnings;
use parent 'Sid::Api::Base';
use Sid::Logic;
use Encode ();
use Smart::Args qw/args/;
use Class::Accessor::Lite 0.05 ( ro => [qw/config logic/] );

sub new {
    args my $class, my $config => { isa => 'Sid::Config', required => 1 };
    my $self = $class->SUPER::new;
    $self->{config} = $config;
    $self->{logic}  = Sid::Logic->new(config=>$config);
    return $self;
}

sub write_doc {
    my $self = shift;
    
    my $doc = $self->create_doc;
    $self->write_html(doc => $doc); 
}

sub create_doc {
    my $self = shift;
    
    $self->set_debug_msgs('start create document');
    my $doc = $self->logic->create_doc;
    $self->set_debug_msgs('end create document');

    return $doc;
}

sub write_html {
    args my $self, my $doc => { isa => 'Sid::Model::Doc', required => 1 };
    
    $self->set_debug_msgs('start write_html');
    for my $category ( $doc->categories ) {

        $self->set_debug_msgs("start write category @{[$category->id]}");
        my $html = $self->config->xslate->render(
            doc            => $doc,
            current_cat_id => $category->id,
            category       => $category,
        );

        my $encoded_html = Encode::encode_utf8($html);

        Path::Class::File->new( $self->config->html_dir, $category->basename )
          ->openw->print($encoded_html);
        
        $self->set_debug_msgs("end write category @{[$category->id]}");
    }
    $self->set_debug_msgs('end write_html');
}

1;

