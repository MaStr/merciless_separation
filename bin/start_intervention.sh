#!/bin/bash

/etc/init.d/privoxy start

sudo iptables -t nat -I PREROUTING -i ovpn-tun  -p tcp --dport 80 -j REDIRECT --to-ports 8118

#Disable all HTTPS
sudo iptables -I FORWARD -p tcp --dport 443 -j REJECT
