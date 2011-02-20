package Sid::Api;
use strict;
use warnings;
use Sid::Logic;
use Encode ();
use Smart::Args qw/args/;
use Class::Accessor::Lite 0.05 ( ro => [qw/config/] );

### TODO: 処理時間計測
### TODO: try catch

sub new {
    args my $class, my $config => { isa => 'Sid::Config', required => 1 };
    return bless { config => $config }, $class;
}

sub create_doc {
    my $self = shift;

    return Sid::Logic->create_doc( config => $self->config ); 
}

sub write_html {
    args my $self, my $doc => { isa => 'Sid::Model::Doc', required => 1 };
    
    for my $category ( $doc->categories ) {

        my $html = $self->config->renderer->render(
            doc            => $doc,
            current_cat_id => $category->id,
            category       => $category,
        );

        my $encoded_html = Encode::encode_utf8($html);
        Path::Class::File->new( $self->config->html_dir, $category->basename )
          ->openw->print($encoded_html);
    }
}

1;

