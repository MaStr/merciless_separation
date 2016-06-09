#!/bin/bash

/etc/init.d/privoxy start

sudo iptables -t nat -I PREROUTING -i ovpn-tun  -p tcp --dport 80 -j REDIRECT --to-ports 8118
