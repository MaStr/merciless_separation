#!/usr/bin/perl
use strict;

use utf8;
use HTTP::Proxy qw ":log" ;

my $port=13128;
my $max_connections=2048;
my $max_clients=64;

use Getopt::Std;

my %opt;

my $proxy;
$proxy = HTTP::Proxy->new;

sub push_filter_gender(){
    use plugins::gender  ;
    $proxy->push_filter(
                mime => 'text/html' ,
                response => Gender->new()
    );
}
sub push_filter_vocals(){
    use HTTP::Proxy::BodyFilter::tags;
    use HTTP::Proxy::BodyFilter::htmltext; 
   
    use myhtmltext; 
    $proxy->push_filter(
		mime     => 'text/html',
		response => HTTP::Proxy::BodyFilter::tags->new,
		response => myhtmltext->new(
			sub { tr/aeiouAEIOU/UUUUUooooo/ }
		) 	
    );
}
sub push_filter_vocalsReCapitalize(){
    use HTTP::Proxy::BodyFilter::tags;
    use HTTP::Proxy::BodyFilter::htmltext; 
   
    use myhtmltext; 
    $proxy->push_filter(
		mime     => 'text/html',
		response => HTTP::Proxy::BodyFilter::tags->new,
		response => myhtmltext->new(
			sub { tr/aeiouAEIOUbcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ/UUUUUoooooBCDFGHJKLMNPQRSTVWXYZbcdfghjklmnpqrstvwxyz/ }
		) 	
    );
}
sub push_filter_vocalsDeCapitalize(){
    use HTTP::Proxy::BodyFilter::tags;
    use HTTP::Proxy::BodyFilter::htmltext; 
   
    use myhtmltext; 
    $proxy->push_filter(
		mime     => 'text/html',
		response => HTTP::Proxy::BodyFilter::tags->new,
		response => myhtmltext->new(
			sub { tr/aeiouAEIOUBCDFGHJKLMNPQRSTVWXYZ/UUUUUooooobcdfghjklmnpqrstvwxyz/ }
		) 	
    );
}

sub push_filter_Success(){
    use HTTP::Proxy::BodyFilter::tags;
    use HTTP::Proxy::BodyFilter::htmltext; 
   
    use myhtmltext; 
    $proxy->push_filter(
		mime     => 'text/html',
		response => HTTP::Proxy::BodyFilter::tags->new,
        response => myhtmltext->new( 
                    sub { s/Success/--%%--%%--%%--%%--%%/ig  } 
                    ),
		response => myhtmltext->new( 
                    sub { s/\w/x/ig }
		            ),
        response => myhtmltext->new(
                    sub { s/--%%--%%--%%--%%--%%/Success/ig }
                    )
    );
}

    # alternate initialisation

    $proxy->port( $port ); # the classical accessors are here!

    # $proxy->logmask(STATUS | PROCESS);
    $proxy->host( undef );
    $proxy->max_clients( $max_clients );
    $proxy->max_connections( $max_connections );


    push_filter_vocalsDeCapitalize();

    # this is a MainLoop-like method
    $proxy->start;
