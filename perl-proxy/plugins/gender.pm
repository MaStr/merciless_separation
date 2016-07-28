#!/usr/bin/perl
package Gender;

use base qw( HTTP::Proxy::BodyFilter );

# a simple modification, that may break things
sub filter {
my ( $self, $dataref, $message, $protocol, $buffer ) = @_;
	# s/ (he)([ \,\.\-'])/ s\$1\$2/
       $$dataref =~ s/[ >](he)([ \&\,\.\-\'\’])/ she$2/g;
       $$dataref =~ s/[ >](He)([ \&\,\.\-\'\’])/ She$2/g;
       $$dataref =~ s/ him/ her/g;
       $$dataref =~ s/ his / hers /g;
}

1;
