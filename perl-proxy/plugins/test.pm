#!/usr/bin/perl
package Test;

use base qw( HTTP::Proxy::BodyFilter );
use Data::Dumper;

# a simple modification, that may break things
sub filter {
my ( $self, $dataref, $message, $protocol, $buffer ) = @_;
 #      $$dataref =~ s/Soldat/Schlumpf/g;
 #      $$dataref =~ s/Soldaten/Schm\&uuml\;/g;

	#print Dumper($dataref, $message, $protocoll, $buffer) ;

	while ( $$dataref =~ /\=([\'\"])([\w\/\.\_\-]+\.png)([\"\'])/g ) {
		print "$1 => pos ". pos $x ;
	}
}

1;
