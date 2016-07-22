#!/bin/bash

FOLDER=/opt/merciless_separation/perl-proxy
PID="/var/run/perl-proxy.pid"

kill  `cat "$PID"`
