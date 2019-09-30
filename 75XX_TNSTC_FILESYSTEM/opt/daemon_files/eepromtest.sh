#!/bin/sh
timeout 5s eeprom -r -s 0 > /dev/null
if [ $? -eq 0 ]
then
        echo 1 > /usr/share/status/eeprom_teststatus
else
        echo 0 > /usr/share/status/eeprom_teststatus
fi
