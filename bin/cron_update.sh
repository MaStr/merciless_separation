#!/bin/sh

#  Script to run inside cron and update MERCILESS SEPARATION hosts

# Run environment
environment='lab'

# Email notification to
EMAIL="kurvenjunkie@gmail.com"

# Wait time when system as active VPN connection
#   This should prevent that multiple disconnects can occur.
#   And that the VPN connection is not sticky to the first in update
#   order.
SLEEP_TIME=$(( 5 * 60 ))

# Logfile 
#  Take a protocol of the runtime, which should be sent over to $EMAIL
log=/tmp/update.log

# Current active OpenVPN Connection
#   We can make use of the munin plugin..
connections=$( /etc/munin/plugins/openvpn  | awk '{ print $2 }' ) 


send_mail(){
    mail -s $(hostname)"-Update report" $EMAIL < $log
}

test -e $log && rm $log
echo "Running update script on " $( hostname ) $( date ) > $log

if [ "$connections" = "0" ] ; then 
    echo "Found active connections: $connections" >>  $log
    echo " Sleeping for $SLEEP_TIME " >>  $log
    sleep $SLEEP_TIME
fi

cd /opt/merciless_separation/

bin/update.sh -e "$environment" &>> $log
RC=$?

case $RC in
    "0") send_mail && exit 0
        ;;
    "1") exit 0
        ;;
    *) cat $log
       echo "AN UNEXPECTED ERROR OCCURED!!"
esac
