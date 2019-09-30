#!/bin/sh

var=`/usr/sbin/iw dev wlan0 link | grep "signal" | awk '{print $2}' | cut -c2` 

if [ $var -ge  4 ]  &&  [ $var -le  6 ]
then
echo 4 > /opt/daemon_files/signal_level
elif [ $var -ge  6 ]
then
echo 5 > /opt/daemon_files/signal_level
else
echo $var > /opt/daemon_files/signal_level
fi



