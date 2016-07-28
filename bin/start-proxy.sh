#!/bin/bash

FOLDER=/opt/merciless_separation/perl-proxy
PID="/var/run/perl-proxy.pid"

cd "$FOLDER"
/usr/bin/perl "$FOLDER"/proxy.pl  &> "$FOLDER/log/proxy.log"  &
rc=$!
echo $! > "$PID"
