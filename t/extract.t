#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

BEGIN { use_ok("Sid::Extract"); }

my $xhtml = <<"EOF";
<h1>test</h1>
<p>this is description</p>
<p>this is not description</p>
<h2>heading</h2>
<p>
<em>em</em>. 
<em>emphasis</em>.  
<em>one em</em>. 
<em>em</em> too.
</p>
EOF

subtest 'extract' => sub {
    my $metadata = Sid::Extract->metadata_from($xhtml);
    is_deeply $metadata,
      {
        title       => 'test',
        keywords    => [ 'em', 'emphasis', 'one em' ],
        description => 'this is description',
      };
};

done_testing();

