package Sid::Xslate::Bridge;
use strict;
use parent qw( Text::Xslate::Bridge );
use Text::Xslate qw( html_builder );
use Text::Markdown ();
    
__PACKAGE__->bridge(
    function => {
        markdown      => html_builder { Text::Markdown::markdown(@_) },
        html_unescape => html_builder { @_ }
    }
);  
        
1;
