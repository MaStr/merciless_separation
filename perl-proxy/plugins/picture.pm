#!/usr/bin/perl
package Gender;

use base qw( HTTP::Proxy::BodyFilter );

# a simple modification, that may break things

sub new(){
	my $url = shift;
	my $self = Super::new();
	$self->url=$url;
	return $self;
}

sub filter {
my ( $self, $dataref, $message, $protocol, $buffer ) = @_;

  my $target_url = $self->url;
  my $mime = $message->headers()->header('Content-Type');
  my @replaceURL;
  if ( $mime == 'text/html' )) {
	  while ( $$dataref  =~ /\=([\'\"])([\w\/\.\_\-]+\.(png|jpg|jpeg))([\"\'])/g ) {
        	        print "$2 => pos ". pos ($line) . "\n" ;
                	push (@replaceURL, $2 );
  	}
  }
  foreach my $word ( @replaceURL ) {
	
        $$dataref =~ s/$word/$target_url/g ;
  }
	
}

1;
