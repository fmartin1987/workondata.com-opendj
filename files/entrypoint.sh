#!/bin/sh
set -e

if [ "$1" = "start" ]; then
    if [ "$PASSWORD" != "admin" ]; then
        encoded=$(/opt/opendj/bin/encode-password -s SSHA512 -c $PASSWORD | awk {'print $3'} | sed -e 's/^.//' -e 's/.$//' | sed 's/\//\\\//g')
        sed -i "s/^userpassword.*/userpassword: ${encoded}/" /opt/opendj/config/config.ldif
    fi
    /opt/opendj/bin/start-ds --nodetach
else
    exec "$@"
fi
