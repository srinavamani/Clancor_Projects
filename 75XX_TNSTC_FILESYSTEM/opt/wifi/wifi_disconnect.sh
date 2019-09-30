#!/bin/sh

echo 0 > /sys/class/gpio/gpio504/value
sleep 1

connmanctl disable wifi



