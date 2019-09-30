#!/bin/sh
timeout 5s nfctest poll > /dev/null
if [ $? -eq 0 ]
then
	echo 1 > /usr/share/status/rfid_teststatus
else
	echo 0 > /usr/share/status/rfid_teststatus
fi
