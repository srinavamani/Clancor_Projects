#!/bin/bash
case $1 in
"start")
	if [ -f /usr/share/status/screen_lock ]
	then
		rm /usr/share/status/screen_lock
	fi
	/sbin/hwclock -s	
	timestamp_current=`date +"%s"`
        timestamp_previous=`cat /usr/share/status/timestamp`
	if [ -f "/usr/share/status/timestamp" ]
	then
		if [ "$timestamp_current" -gt "$timestamp_previous" ]
		then
			echo 1 > /usr/share/status/timesync
		else
			echo 0 > /usr/share/status/timesync
		fi
	fi
	echo `cat /usr/share/status/KEYPAD_buzzer` > /proc/keypad/KEYPAD_buzzer
	if [ -f "/usr/share/status/backlight_backup" ]
	then
		/bin/cp /usr/share/status/backlight_backup /usr/share/status/backlight_read_time
		/bin/rm /usr/share/status/backlight_backup
	fi

#	var1=`eepromtool -r -s 3`
#	if [ $var1 -ge 0 ]; then
#		echo $var1 > /usr/share/status/debug/printLength.log
#	else
#		eepromtool -w -s 3 "0"
#		echo -n "0" > /usr/share/status/debug/printLength.log
#	fi
#	printf `cat /usr/share/status/debug/printLength.log` > /usr/share/status/debug/printLength.log
#	DEVICE_START_TIME=`date +"%s"`
#	echo $DEVICE_START_TIME > /usr/share/status/debug/device_start_time.log
#	var2=`eepromtool -r -s 4`                                               
#        if [ $var2 -ge 0 ]; then                                                
#                echo $var2 > /usr/share/status/debug/deviceOnStatus.log         
#        else                                                                    
#                eepromtool -w -s 4 "0"                                          
#                echo -n "0" > /usr/share/status/debug/deviceOnStatus.log        
#        fi

	echo 1 > /usr/share/status/ntp_status
	sh /opt/daemon_files/GPIO.sh
	insmod /opt/daemon_files/printer.ko
	insmod /opt/daemon_files/mt7601Usta.ko
	insmod /opt/daemon_files/pn5xx_i2c.ko
        insmod /opt/daemon_files/backlightctl.ko	
	insmod /opt/daemon_files/fbrefresh.ko
	touch /home/root/is_download	
	/usr/sbin/crond
	/opt/daemon_files/keyd -d
	/opt/daemon_files/standbyd -d
#	/opt/daemon_files/taskd -d
#	/opt/daemon_files/netd -d
	/opt/daemon_files/gpiod
	/opt/daemon_files/rmgmtd -d
	/opt/daemon_files/master_download -d
	sh /usr/share/scripts/gadgets/disable.sh start
#	ubiattach /dev/ubi_ctrl -m 3 -O 2048
#        mount -t ubifs ubi1:user /media/nand
	echo 0 > /dev/fbrefresh0
	if [ -f /media/sdcard/MACHINEid.enc ]
	then
		chattr +i /media/sdcard/MACHINEid.enc;
	fi
	if [ -f /media/sdcard/MACHINEserial.enc ]
	then
		chattr +i /media/sdcard/MACHINEserial.enc;
	fi
	if [ -f /media/sdcard/MACHINEID_status ]
	then
		chattr +i /media/sdcard/MACHINEID_status;
	fi
	if [ -f /usr/share/status/rfid_teststatus ]
	then
		rm /usr/share/status/rfid_teststatus
	fi
	sh /opt/daemon_files/nfctest.sh &
;;
"stop")

#	eepromtool -w -s 3 `cat /usr/share/status/debug/printLength.log`
#	DEVICE_END_TIME=`date +"%s"`                                            
#	echo $DEVICE_END_TIME > /usr/share/status/debug/device_end_time.log     
#	DEVICE_START_TIME=`cat /usr/share/status/debug/device_start_time.log`   
#	DEVICE_END_TIME=`cat /usr/share/status/debug/device_end_time.log`    
#	DEVICE_ON_TIME="$(($DEVICE_END_TIME - $DEVICE_START_TIME))"          
#	FILE_TIME=`cat /usr/share/status/debug/deviceOnStatus.log`          
#	FILE_TIME="$(($FILE_TIME * 60))" 
#	STATIC_DURATION="$(($DEVICE_ON_TIME + $FILE_TIME))"                 
#	STATIC_DURATION="$(($STATIC_DURATION / 60))" 
#	if [ $STATIC_DURATION -ge 0 ]
#	then
#		eepromtool -w -s 4 `echo $STATIC_DURATION`
#	fi

#	sh /usr/share/scripts/gadgets/serialgadget.sh stop
	rmmod printer
	rmmod mt7601Usta
	rmmod pn5xx_i2c
	rmmod fbrefresh
	killall crond
	killall taskd
	killall keyd
	killall standbyd
	killall netd
	killall gpiod
	killall rmgmtd
	killall master_download
#	umount /media/nand
#        ubidetach /dev/ubi_ctrl -m 3
;;
esac

#/opt/sdk/bin/ClanCor_HHC -qws -display VNC:LinuxFb 2>/opt/os/log/Clancor.log &
