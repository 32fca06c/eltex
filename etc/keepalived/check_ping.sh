#!/bin/bash
 
# host to ping
# there - default gw
HOST=<default_gw_ip>
# -q quiet
# -c nb of pings to perform
ping -q -c5 $HOST > /dev/null
 
# $? var keeping result of execution
# previous command
if [ $? -eq 0 ]
    then
        echo `date +"%T %F"` "OK gw reachable"
        EXIT_CODE=0
    else
        echo `date +"%T %F"` "ERROR gw unreacheble!"
        EXIT_CODE=1
fi
 
exit $EXIT_CODE