#!/bin/bash

/etc/init.d/privoxy stop


if sudo iptables -t nat -L | grep -q -e "tcp dpt:http redir ports 8118" ; then
	sudo iptables -t nat -D PREROUTING -i ovpn-tun  -p tcp --dport 80 -j REDIRECT --to-ports 8118
fi

if  sudo iptables -L FORWARD | grep -q -e "tcp dpt:https" ; then
	sudo iptables -D FORWARD -p tcp --dport 443 -j REJECT
fi
