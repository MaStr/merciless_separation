#!/bin/sh



config="/etc/cjdroute.conf"

# FOR SOME REASON this has no effect , it seems
#  I'm running a version that does not take account the piping
test -e "/opt/cjdns/cjdroute.conf" && config="/opt/cjdns/cjdroute.conf"

echo "Starting CJDNS with $config"
cjdroute < "$config"
sleep 1
pgrep  cjdroute > /var/run/cjdns.pid

