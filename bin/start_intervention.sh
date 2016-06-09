#!/bin/bash

/etc/init.d/privoxy start

sudo iptables -t nat -I PREROUTING -i tun0 -p tcp --dport 80 -j REDIRECT --to-ports 8118
