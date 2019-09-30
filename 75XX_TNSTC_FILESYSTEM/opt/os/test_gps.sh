#!/bin/bash


cat /dev/ttyS8 > /home/root/test &

sleep 1

killall cat </dev/null &

size=`ls -lh /home/root/test | awk '{print $5}'`

if [ "$size" == "0" ]
then

echo 0 > /home/root/gps_sat

else

echo 1 > /home/root/gps_sat

fi
