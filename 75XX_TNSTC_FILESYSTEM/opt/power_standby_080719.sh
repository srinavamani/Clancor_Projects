#!/bin/bash
sh /usr/share/scripts/Buzzer 1
umount /media/sdcard
sync
sync; echo 3 > /proc/sys/vm/drop_caches
echo "Caches cleared"
auto_time=`cat /usr/share/status/auto_shutdown`
autos_count=`expr $auto_time / 300`
if [ $autos_count -eq 0 ]
then
	autos_count=-1
fi
start_count=0
if [ -f /var/log/dmesg ]
then
	echo "Dmesg File Exist"
else
	dmesg -c > /var/log/dmesg
	echo "Dmesg File Not Exist"
fi
while [ true ]
do
	echo "Loop Count: $start_count"
	batt_status=`cat /sys/class/power_supply/NUC970Bat/present`
	echo "Auto Shutdown Count: $autos_count"
	echo "Battery Status: $batt_status"
	if [  $start_count -eq $autos_count -o $batt_status -lt 78 ]
	then
		sh /usr/share/scripts/Buzzer 1
		/sbin/poweroff
		sleep 1
		back_present=`cat /usr/share/status/present_backlight`
		sh /usr/share/scripts/backlight $back_present
		break
	fi
	start_count=`expr $start_count + 1`
	dmesg -c >> /var/log/dmesg
#	sleep 0.5
	/usr/bin/rtc_read -set 5 > /dev/null &
	echo 0 > /sys/class/gpio/gpio108/value
#	sh /usr/share/scripts/Buzzer 1
	touch /usr/share/status/SCREEN_timeout
	file=$(cat /usr/share/status/present_backlight.txt)
	sh /usr/share/scripts/backlight 0;
	five_reg=`cat /sys/class/gpio/gpio43/value`
	three_reg=`cat /sys/class/gpio/gpio42/value`
	if [ $five_reg == '1' ]
	then
		echo 0 > /sys/class/gpio/gpio43/value
	fi
	if [ $three_reg == '1' ]
	then
		echo 0 > /sys/class/gpio/gpio42/value
	fi
	
	echo out > /sys/class/gpio/gpio164/direction
	echo 0 > /sys/class/gpio/gpio164/value
	sleep 0.5
	echo mem > /sys/power/state
	echo 1 > /sys/class/gpio/gpio164/value
	echo in > /sys/class/gpio/gpio164/direction
	
	if [ $five_reg == '1' ]                     
	then                                        
	        echo 1 > /sys/class/gpio/gpio43/value
	fi                                          
	if [ $three_reg == '1' ]                    
	then                                        
	        echo 1 > /sys/class/gpio/gpio42/value
	fi
	#sh /usr/share/scripts/Buzzer 1
	echo 1 > /sys/class/gpio/gpio108/value

	dmesg | grep "Interrupt"
	if [ $? -eq 0 ]
	then
		dmesg -c >> /var/log/dmesg
		sh /usr/share/scripts/Buzzer 2
		echo 0 > /sys/class/gpio/gpio108/value
	else
		back_present=`cat /usr/share/status/present_backlight`
		sh /usr/share/scripts/backlight $back_present
		sh /usr/share/scripts/Buzzer 1
#		sleep 1
		break
	fi
done
