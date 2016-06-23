#!/bin/bash

/etc/init.d/privoxy stop

sudo iptables -t nat -D PREROUTING -i ovpn-tun  -p tcp --dport 80 -j REDIRECT --to-ports 8118

#sudo iptables -D FORWARD -p tcp --dport 443 -j REJECT
