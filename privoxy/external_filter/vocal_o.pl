#!/usr/bin/perl 
use strict;

use HTTP::Proxy::BodyFilter::htmltext;

my $message="";

my $fil  = HTTP::Proxy::BodyFilter::htmltext->new(
#                sub { tr/a-zA-z/n-za-mN-ZA-M/ }
                sub { tr/aeiouAEIOU/UUUUUooooo/ } 
                        );

while ( <STDIN> ) {
    $message .= $_;
}
    $fil->filter(   \$message  );

    print $message;

exit 0
