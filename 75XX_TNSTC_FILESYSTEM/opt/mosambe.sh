#!/bin/sh

VAR=`cat /sys/bus/usb/devices/2-2:1.0/tty/ttyACM*/uevent | grep "tty" | cut -c 15,16,17`

#echo $VAR

ln -sf /dev/ttyACM$VAR /dev/mosambe 
