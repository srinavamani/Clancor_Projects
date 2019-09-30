#!/bin/bash
batt_status=`cat /sys/class/power_supply/NUC970Bat/present`
auto_time=`cat /usr/share/status/auto_shutdown`
autos_count=`expr $auto_time / 60`
echo "Battery Status: $batt_status"

if [ -f /var/log/dmesg ]
then
	echo "Dmesg File Exist"
else
	dmesg -c > /var/log/dmesg
	echo "Dmesg File Not Exist"
fi

if [ $batt_status -lt 77 ]
then
	sh /usr/share/scripts/Buzzer 2
	/sbin/poweroff
else
	dmesg -c >> /var/log/dmesg
	/usr/bin/rtc_read -set 20 > /dev/null &
	echo 0 > /sys/class/gpio/gpio108/value
	sh /usr/share/scripts/Buzzer 1
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
	echo 3 > /proc/sys/vm/drop_caches
	sleep 0.5
	echo mem > /sys/power/state
	echo 3 > /proc/sys/vm/drop_caches
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
	echo 1 > /sys/class/gpio/gpio108/value
	back_present=`cat /usr/share/status/present_backlight`
	sh /usr/share/scripts/backlight $back_present
	sh /usr/share/scripts/Buzzer 1
	
	dmesg | grep "Interrupt"
	if [ $? -eq 0 ]
	then
		sh /usr/share/scripts/Buzzer 2
		/sbin/poweroff
	fi	
fi
