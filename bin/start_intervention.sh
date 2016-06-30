#!/bin/bash

/etc/init.d/privoxy start



if ! sudo iptables -t nat -L | grep -q -e "tcp dpt:http redir ports 8118" ; then 
    sudo iptables -t nat -I PREROUTING -i ovpn-tun  -p tcp --dport 80 -j REDIRECT --to-ports 8118
else
    echo "iptables transparent HTTP rule existing, skipping."
fi


#Disables HTTPS Block
if [ "1" -eq "0" ] ; then
	#Disable all HTTPS
	if ! sudo iptables -L FORWARD | grep -q -e "tcp dpt:https" ; then 
		sudo iptables -I FORWARD -p tcp --dport 443 -j REJECT
	else
	    echo "iptables block FORWARD HTTPS  existing, skipping."
	fi
fi
