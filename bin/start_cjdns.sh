#!/bin/sh

config="/etc/cjdroute.conf"

test -e "/opt/cjdns/cjdroute.conf" && config="/opt/cjdns/cjdroute.conf"

echo "Starting CJDNS with $config"
cjdroute < "$config"
sleep 1
pgrep  cjdroute > /var/run/cjdns.pid

