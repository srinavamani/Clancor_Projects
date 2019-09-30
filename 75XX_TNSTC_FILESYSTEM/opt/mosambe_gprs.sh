#!/bin/sh

VAR=`cat /sys/bus/usb/devices/2-1.7:1.6/tty/ttyACM*/uevent | grep "tty" | cut -c 15,16,17`
VAR1=`cat /sys/bus/usb/devices/2-1.7:1.8/tty/ttyACM*/uevent | grep "tty" | cut -c 15,16,17`
VAR2=`cat /sys/bus/usb/devices/2-1.7:1.10/tty/ttyACM*/uevent | grep "tty" | cut -c 15,16,17`

#echo $VAR
#echo $VAR1
#echo $VAR2

ln -sf /dev/ttyACM$VAR /dev/ttyGPRS3
ln -sf /dev/ttyACM$VAR1 /dev/ttyGPRS4 
ln -sf /dev/ttyACM$VAR2 /dev/ttyGPRS5 
