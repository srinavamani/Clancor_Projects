#!/bin/bash
case $1 in
"start")
	/sbin/hwclock -s	
	echo `cat /usr/share/status/KEYPAD_buzzer` > /proc/keypad/KEYPAD_buzzer
	if [ -f "/usr/share/status/backlight_backup" ]
	then
		/bin/cp /usr/share/status/backlight_backup /usr/share/status/backlight_read_time
		/bin/rm /usr/share/status/backlight_backup
	fi

	var1=`eepromtool -r -s 3`
	if [ $var1 -ge 0 ]; then
		echo $var1 > /usr/share/status/debug/printLength.log
	else
		eepromtool -w -s 3 "0"
		echo -n "0" > /usr/share/status/debug/printLength.log
	fi

	printf `cat /usr/share/status/debug/printLength.log` > /usr/share/status/debug/printLength.log

	DEVICE_START_TIME=`date +"%s"`
	echo $DEVICE_START_TIME > /usr/share/status/debug/device_start_time.log

	var2=`eepromtool -r -s 4`                                               
        if [ $var2 -ge 0 ]; then                                                
                echo $var2 > /usr/share/status/debug/deviceOnStatus.log         
        else                                                                    
                eepromtool -w -s 4 "0"                                          
                echo -n "0" > /usr/share/status/debug/deviceOnStatus.log        
        fi

	sh /opt/daemon_files/GPIO.sh
	insmod /opt/daemon_files/printer.ko
#	insmod /opt/daemon_files/mt7601Usta.ko
	insmod /opt/daemon_files/pn5xx_i2c.ko
        insmod /opt/daemon_files/backlightctl.ko		
#	/usr/sbin/crond
	/opt/daemon_files/keyd -d
	/opt/daemon_files/standbyd -d
	/opt/daemon_files/taskd -d
#	/opt/daemon_files/netd -d
	/opt/daemon_files/gpiod
	/opt/daemon_files/rmgmtd -d
	sh /usr/share/scripts/gadgets/disable.sh start
;;
"stop")
	eepromtool -w -s 3 `cat /usr/share/status/debug/printLength.log`

	DEVICE_END_TIME=`date +"%s"`                                            
	echo $DEVICE_END_TIME > /usr/share/status/debug/device_end_time.log     
	DEVICE_START_TIME=`cat /usr/share/status/debug/device_start_time.log`   
	DEVICE_END_TIME=`cat /usr/share/status/debug/device_end_time.log`    
	DEVICE_ON_TIME="$(($DEVICE_END_TIME - $DEVICE_START_TIME))"          
	FILE_TIME=`cat /usr/share/status/debug/deviceOnStatus.log`          
	FILE_TIME="$(($FILE_TIME * 60))" 
	STATIC_DURATION="$(($DEVICE_ON_TIME + $FILE_TIME))"                 
	STATIC_DURATION="$(($STATIC_DURATION / 60))" 
	if [ $STATIC_DURATION -ge 0 ]
	then
		eepromtool -w -s 4 `echo $STATIC_DURATION`
	fi

#	sh /usr/share/scripts/gadgets/serialgadget.sh stop
	rmmod printer
#	rmmod mt7601Usta
	rmmod pn5xx_i2c
#	killall crond
	killall keyd
	killall standbyd
	killall netd
	killall gpiod
	killall rmgmtd
;;
esac

#/opt/sdk/bin/ClanCor_HHC -qws -display VNC:LinuxFb 2>/opt/os/log/Clancor.log &
