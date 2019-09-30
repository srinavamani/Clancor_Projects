#!/bin/sh

echo 1 > /sys/class/gpio/gpio502/value
sleep 1
echo 1 > /sys/class/gpio/gpio504/value
sleep 1

connmanctl enable wifi
connmanctl scan wifi



