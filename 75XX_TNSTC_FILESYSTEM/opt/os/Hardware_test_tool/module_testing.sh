#!/bin/sh
#
# Script to check hardware functionalities
#
# Author: SriNavamani
#
# Copyright @ Clancor Technovates


## TODO 


## GPIO VARIABLES

AUDIO_POWER=167
CAMERA_SWITCH=168
BARCODE_POWER=196
BARCODE_TRIGGER=197
CAMERA_POWER=
FP_POWER=163
MAG_POWER= 
RFID_POWER=35
SAM_POWER=
SMART_POWER=
GPS_POWER=174
GPRS_VOLT_POWER=42
FIVE_VOLT_POWER=43
HUB_POWER=143
GPRS_POWER=288
GPRS_WAKEUP=289
CAMERA_FLASH=
WIFI_POWER=164
FUTURE_USE=163
PAPER_SENSE=162


gpio_export()
{

echo $FUTURE_USE > /sys/class/gpio/export

sleep 1

echo out > /sys/class/gpio/gpio$FUTURE_USE/direction
echo out > /sys/class/gpio/gpio$PAPER_SENSE/direction
}

gpio_unexport()
{

echo $FUTURE_USE > /sys/class/gpio/unexport
echo in > /sys/class/gpio/gpio$PAPER_SENSE/direction
}
# 3G module testing

#	killall ClanCor_HHC

 #	./TestReport -qws &

	echo -e "\n\n"
	echo -e ".............Hi,All...Welocme to the Hardware test tool.........."
	echo -e "\n\n"
	read -p "PRESS N for fresh report (or) PRESS ENTER for continue the report : " report

	if [ "$report" = "N" ] || [ "$report" = "n" ]
	then
	rm helloworld
	touch helloworld
	echo "echo ~E0043-----Test Report for 75XX----- BML~^! > /dev/printer" >> helloworld
	fi

usb_hub_enable()
{
	echo 1 > /sys/class/gpio/gpio$FIVE_VOLT_POWER/value
	echo 1 > /sys/class/gpio/gpio$HUB_POWER/value
}

buzzer_success()
{
sh /usr/share/scripts/Buzzer 3
}

buzzer_failure()
{
sh /usr/share/scripts/Buzzer 4
}

tested_ok()
{
echo -e "\n"
	echo "####################################################"
	echo "##################   TESTED OK   ###################"
	echo "####################################################"
echo -e "\n"
}

module_not_found()
{
	echo -e "\n"
	echo "****************************************************"
	echo "**************    Module Not found   ***************"
	echo "****************************************************"
	echo -e "\n"
}

module_found()
{
	echo -e "\n"
	echo "####################################################"
	echo "##############   GPS module present   ##############"
	echo "####################################################"
	echo -e "\n"
}

back_light()
{
	sh /usr/share/scripts/backlight 0
	echo "Brightness level 0"
	sleep 1 
	sh /usr/share/scripts/backlight 1
	echo "Brightness level 1"
	sleep 1 
	sh /usr/share/scripts/backlight 2
	echo "Brightness level 2"
	sleep 1
	sh /usr/share/scripts/backlight 3
	echo "Brightness level 3"
	sleep 1 
	sh /usr/share/scripts/backlight 4
	echo "Brightness level 4"
	sleep 1 
	sh /usr/share/scripts/backlight 5
	echo "Brightness level 5"
	sleep 1 
}

buzzer()
{
	sh /usr/share/scripts/Buzzer 1
	echo "Buzzer - Long beep"
	sleep 1
	sh /usr/share/scripts/Buzzer 2
	echo "Buzzer - Error beep"
	sleep 1
	sh /usr/share/scripts/Buzzer 3
	echo "Buzzer - Single beep"
	sleep 1
	sh /usr/share/scripts/Buzzer 4
	echo "Buzzer - Success beep"
	sleep 1
}


while [ 1 ]
do

echo -e "\n"
echo " 75xx Hardware Test Tool  "
echo " Module Code	       Module Name    "
echo "                                          "
echo "	 1		Machine id       "
echo "	 2		GPIO          "
echo "	 3		Backlight             "
echo "	 4		Buzzer        "
echo "	 5		USB hub          "
echo "	 6		GPRS  (TBD)           "
echo "	 7		GPS"
echo "	 8		Magnetic card reader   "
echo "	 9		Barcode reader         "
echo "	10		RTC            "
echo "	11		Ethernet            "
echo "	12		RFID "
echo "	13		SAM card reader"
echo "	14		SMART card reader          "
echo "	15		Camera           "
echo "	16		Audio    "
echo "	17		Keypad         "
echo "	18		Fingure Print         "
echo "	19		wifi         "
echo "	20		Bluetooth         "
echo "	21		Printer         "
echo "	 0		Exit         "

echo -e "\n"
read -p "Enter the Module Code : " module
echo -e "\n"

if [ $module -lt 22 ]
then

case $module in

####################   Machine ID   #############################

1)



	if [ -e "/sys/bus/i2c/devices/0-0050/eeprom" ]
	then
	echo -e "---------------   Reading Machine id and Model id   ------------------\n\n"
	machine_id=`cat /sys/bus/i2c/devices/0-0050/eeprom | hexdump -C | grep 00001000 | awk '{print $18}' > new
	cut -c2-10 new`

	model_id=`cat /sys/bus/i2c/devices/0-0050/eeprom | hexdump -C | grep 00001010 | awk '{print $18}' > new
	cut -c3-10 new`

	echo "Machine ID - $machine_id"
	echo -e "Model   ID - $model_id\n\n"
	
	read -p "To change the ID's PRESS C (or) PRESS ENTER to continue : " ID
	if [ "$ID" = "C" ] || [ "$ID" = "c" ]
	then
	echo -e "\nEnter 9 char of machine id"
	read -n 9 machine
	echo -e "\nEnter 8 char of model id"	
	read -n 8 model
	touch /usr/share/status/bbb-eeprom.dump000080
	echo $machine....... > /usr/share/status/bbb-eeprom.dump
	echo $model........ >> /usr/share/status/bbb-eeprom.dump
	cat /usr/share/status/bbb-eeprom.dump > /sys/bus/i2c/devices/0-0050/eeprom
	echo -e "\n\n"

	machine_new=`cat /sys/bus/i2c/devices/0-0050/eeprom | hexdump -C | grep 00001000 | awk '{print $18}' > new
	cut -c2-10 new`

	model_new=`cat /sys/bus/i2c/devices/0-0050/eeprom | hexdump -C | grep 00001010 | awk '{print $18}' > new
	cut -c3-10 new`
	echo "####################################################"
	echo "#####   Machine ID and Model ID have changed  ######"
	echo "####################################################"
	echo -e "\n"

	echo "Machine ID - $machine_new"
	echo -e "Model   ID - $model_new"

	echo "echo ~E0035Machine ID - $machine_new BML~^! > /dev/printer" >> helloworld
	echo "echo ~E0032Model ID - $model_new BML~^! > /dev/printer" >> helloworld
	
	else

	echo "echo ~E0035Machine ID - $machine_id BML~^! > /dev/printer" >> helloworld
	echo "echo ~E0032Model ID - $model_id BML~^! > /dev/printer" >> helloworld
	
	fi

	else
	echo "<<<<<<<<<<<<<<<   EEPROM not found   >>>>>>>>>>>>>>>"
	buzzer_failure
	fi	
;;


####################   GPIO   #############################

2)
	for gpio in 35 42 163 166 167 169 174 194 195 196 197 288 289
	do
	check=`cat /sys/kernel/debug/gpio | grep gpio-$gpio | awk '{print $4}'` 
	if [ "$check" = "out" ]
	then
	gpio_var=0
	else
	echo "GPIO $gpio is not created"
	gpio_var=1
	fi	

	if [ "$gpio_var" = "0" ]                                                    
    	then                                                                        
    	cat /sys/kernel/debug/gpio | grep gpio-$gpio                                
   	 fi   
	done

	if [ "$gpio_var" = "0" ]
	then
	echo -e "\n"
	echo "####################################################"
	echo "#############   GPIO's have created   ##############"
	echo "####################################################"

	gpio_unexport
	echo "echo ~E0035GPIO---------------PASSBML~^! > /dev/printer" >> helloworld
	buzzer_success
	else
	echo "echo ~E0035GPIO---------------FAILBML~^! > /dev/printer" >> helloworld
	buzzer_failure
	fi
;;


####################   Backlight   #############################

3) 
	backlightfile="/sys/class/pwm/pwmchip0/pwm0/duty_cycle"
	if [ -e "$backlightfile" ]
	then
	echo "Backlight present"	
	back_light
	echo -e "\n\n"
	read -p "Testing Verification PASS or FAIL [p/f] : " verification
	
	if [ "$verification" = "p" ] || [ "$verification" = "P" ]
	then
	echo "echo ~E0035BackLight----------PASSBML~^! > /dev/printer" >> helloworld
	buzzer_success
	tested_ok	
	else
	echo "echo ~E0035BackLight----------FAILBML~^! > /dev/printer" >> helloworld
	buzzer_failure
	fi

	else
	module_not_found
	echo "echo ~E0035BackLight----------FAILBML~^! > /dev/printer" >> helloworld
	buzzer_failure
	fi	

;;


####################   Buzzer   #############################

4) 

	buzzer	
	echo -e "\n\n"
	read -p "Testing Verification PASS or FAIL [p/f] : " verification

	if [ "$verification" = "p" ] || [ "$verification" = "P" ]
	then
	echo "echo ~E0035Buzzer-------------PASSBML~^! > /dev/printer" >> helloworld
	buzzer_success
	tested_ok
	else
	echo "echo ~E0035Buzzer-------------FAILBML~^! > /dev/printer" >> helloworld
	buzzer_failure
	fi


;;	


####################   USB hub   #############################

5)
	usb_hub_enable	
	sleep 2
	echo -e "\n\n----------------USB hub--------------------\n\n"
	lsusb | grep ub | awk '{print $7 $8 $9 $10 $11 $12 $13 $14 $15}'
	
	hub=`lsusb | grep Hub | awk '{print $7 $8 $9 $10 $11 $12 $13 $14 $15}'`
	if [ "$hub" = "TerminusTechnologyInc.FE2.17-portHub" ]
	then
	
	echo "echo ~E0035USB HUB------------PASSBML~^! > /dev/printer" >> helloworld
	buzzer_success
	echo -e "\n"
	echo "####################################################"
	echo "#############   USB hub detected   #################"
	echo "####################################################"
	echo -e "\n"

	else
	
	echo "echo ~E0035USB HUB------------FAILBML~^! > /dev/printer" >> helloworld
	buzzer_failure
	fi

;;


####################   GPRS   #############################

6)
	killall net
	ifconfig eth0 down
	killall gsmMuxd
	echo -e "\n--------------   Module Checking   -------------"
	sleep 1
	echo 1 > /sys/class/gpio/gpio$GPRS_POWER/value
	echo 1 > /sys/class/gpio/gpio$GPRS_VOLT_POWER/value
#	echo 0 > /sys/class/gpio/gpio$GPRS_WAKEUP/value
	sleep 1
	/opt/daemon_files/gsmMuxd -p /dev/ttyS3 -w -r -s /dev/mux /dev/ptmx /dev/ptmx /dev/ptmx
	sleep 5
	if [ -e "/dev/mux0" ]
	then
	echo -e "\n Module Enabled...\n"

	else
	echo -e "\n Module not enable....\n"
	fi
	sh /opt/daemon_files/GPRS_status.sh sim_presence
	sleep 1
	sh /opt/daemon_files/GPRS_status.sh current_operator
	sleep 1
#	sh /opt/daemon_files/GPRS_status.sh current_operator signal_level
#	sleep 1
	/usr/sbin/pppd call gprs
	sleep 8 
	ping -c 3  8.8.8.8	
	
#	echo -e "\n 2G module Installing...\n"
#	cmuxt -p /dev/ttyO1 -b 115200 -d
#	sleep 4

#	if [ -e "/dev/cmux3" ]
#	then
#	echo -e "\n<<<<<<<<<<<<   cmux ports creating   >>>>>>>>>>>>>>>"
#	touch gprs_data
#	sleep 3
#	sh gprs > gprs_data
#	cat gprs_data
#	sim_presence=`cat gprs_data | grep "+CPIN:" | awk '{print $2}'`
#	if [ "$sim_presence" = "READY" ]
#	then
#	echo -e "***********   PPP crearion **************"
#	touch hai
#	touch hai1
#	sleep 7
#	pppd call gprscmux
#	sleep 5
#	ifconfig -a | grep P-t-P | awk '{print $2}' > hai
#	cut -c6-18 hai > hai1
#	echo -e "\nPPP IP address"
#	cat hai1	
#	echo -e "\n"
#	rm hai
#	rm hai1
#	rm gprs_data
#	ping -c 5 8.8.8.8

	if [ "$?" = "0" ]
	then
	echo "echo ~E0035GPRS---------------PASSBML~^! > /dev/printer" >> helloworld
	buzzer_success
	echo -e "\n"
	echo "####################################################"
	echo "##############   GPRS connected   ##################"
	echo "####################################################"
	echo -e "\n"

	else
	
	echo "echo ~E0035GPRS---------------FAILBML~^! > /dev/printer" >> helloworld
	buzzer_failure
	echo -e "\n"
	echo "####################################################"
	echo "#############   GPRS not connected   ###############"
	echo "####################################################"
	echo -e "\n"
	fi

#	else
#	echo -e "\n<<<<<<<<<<<   SIM not inserted   >>>>>>>>>>>>>>"
#	fi
#	else
#	echo -e "\n<<<<<<<<<<<<   cmux ports are not created   >>>>>>>>>>>>>>>"
#	fi

#	fi

;;


####################   GPS   #############################

7)

	if [ -e "/dev/ttyS2" ]
	then
	echo "--------------------   GPS module detecting   ------------------"
	echo 1 > /sys/class/gpio/gpio$FIVE_VOLT_POWER/value
#	echo 1 > /sys/class/gpio/gpio240/value
#	echo 1 > /sys/class/gpio/gpio250/value
#	sleep 1
#	echo 0 > /sys/class/gpio/gpio250/value
#	sleep 1
#	echo 1 > /sys/class/gpio/gpio250/value
	touch new2
	touch new1
	sleep 1
	cat /dev/ttyS2 | grep E,1 >> new2 &
	cat /dev/ttyS2 | grep GP >> new1 &
	sleep 5
#	echo 0 > /sys/class/gpio/gpio240/value
	killall cat
	size=`ls -l | grep new2 | awk '{print $5}'`
	size1=`ls -l | grep new1 | awk '{print $5}'`
	rm new2
	rm new1

	if [ "$size1" == "0" ];then
	module_not_found
	echo "echo ~E0034GPS----------------FAILBML^!>/dev/printer" >> helloworld
	buzzer_failure
	else
	module_found
	echo "echo ~E0034GPS----------------PASSBML^!>/dev/printer" >> helloworld
	buzzer_success
	fi

	if [ "$size" == "0" ];then
	echo -e "\n"
	echo "####################################################"
	echo "###############   GPS is not fix   #################"
	echo "####################################################"
	echo -e "\n"
	else
	echo -e "\n"
	echo "####################################################"
	echo "###############   GPS is fixed   ###################"
	echo "####################################################"
	echo -e "\n"
	fi
	
	else
	echo "<<<<<<<<<<<<<<<   UART4 is not initialized   >>>>>>>>>>>>>"
	echo "echo ~E0034GPS----------------FAILBML^!>/dev/printer" >> helloworld
	buzzer_failure
	fi	
;;


####################   Magnetic Card Reader   #############################

8)

	touch Magnetic
	echo 1 > /sys/class/gpio/gpio$FIVE_VOLT_POWER/value
#	echo 0 > /sys/class/gpio/gpio241/value
#	echo 1 > /sys/class/gpio/gpio243/value
	echo -e "\n\n*********   Swip your card   ***********\n\n"
	cat /dev/ttyO2 >> Magnetic &
	sleep 4
	killall cat
	cat Magnetic
	sleep 1
	magnetic_size=`ls -l | grep Magnetic | awk '{print $5}'`
	rm Magnetic
	if [ "$magnetic_size" = "0" ]
	then
	module_not_found
	echo "echo ~E0034MagneticCard-------FAILBML^!>/dev/printer" >> helloworld
	buzzer_failure
	else
	echo -e "\n"
	echo "####################################################"
	echo "###   magnetic card reader module present   ########"
	echo "####################################################"
	echo -e "\n"
	echo "echo ~E0034MagneticCard-------PASSBML^!>/dev/printer" >> helloworld
	buzzer_success
	fi
	
;;


####################   Bar Code Read   #############################

9)
	touch Barcode
	echo 1 > /sys/class/gpio/gpio$FIVE_VOLT_POWER/value
	echo 1 > /sys/class/gpio/gpio$BARCODE_POWER/value
	echo -e "\n\n**************   Bar code scanning   ****************"
	sleep 1
	sh barcode_trigger &
	cat /dev/ttyS7 >> Barcode &
	sleep 4
	killall cat
	cat Barcode
	sleep 1
	barcode_size=`ls -l | grep Barcode | awk '{print $5}'`
	if [ "$barcode_size" = "0" ]
	then
	module_not_found
	echo "echo ~E0034Barcode------------FAILBML^!>/dev/printer" >> helloworld
	buzzer_failure
	else
	echo -e "\n"
	echo "####################################################"
	echo "###########   Bar code module present   ############"
	echo "####################################################"
	echo -e "\n"
	echo "echo ~E0034Barcode------------PASSBML^!>/dev/printer" >> helloworld
	buzzer_success
	fi
	
;;


####################   RTC   #############################

10) 
	
	if [ ! -f "/dev/rtc0" ]
	then
	
	date=`hwclock -r /dev/rtc1 | awk '{print $3}'`
	month=`hwclock -r /dev/rtc1 | awk '{print $2}'`
	year=`hwclock -r /dev/rtc1 | awk '{print $5}'`
	time=`hwclock -r /dev/rtc1 | awk '{print $4}'`
	echo "Hardware clock details"	
	echo -e "\nDATE - $date $month $year"
	echo -e "TIME - $time\n\n"
	
	read -p "To change the time PRESS T (or) PRESS ENTER to continue : " time_status

	if [ "$time_status" = "T" ] || [ "$time_status" = "t" ]
	then
	echo -e "\n\nEnter the date and Time"
	echo -e "\nThis is the formate  2013-11-19 15:11:40"
	read time
	date -s "$time"
	echo -e "\n************************* System Time updating ****************************"
	sleep 2
	hwclock -w /dev/rtc
	echo -e "\n*************** Hardware time is syncing with system time *****************\n"
	sleep 2
	date=`hwclock -r /dev/rtc0 | awk '{print $3}'`
	month=`hwclock -r /dev/rtc0 | awk '{print $2}'`
	year=`hwclock -r /dev/rtc0 | awk '{print $5}'`
	time=`hwclock -r /dev/rtc0 | awk '{print $4}'`
	echo "Hardware clock details"	
	echo -e "\nDATE - $date $month $year"
	echo -e "TIME - $time"
	
	echo "echo ~E0035RTC----------------PASSBML~^! > /dev/printer" >> helloworld
	buzzer_success
	else
	
	echo "echo ~E0035RTC----------------PASSBML~^! > /dev/printer" >> helloworld
	buzzer_success
	fi
	else
	echo -e "\n\n ERROR ...  Hardware rtc problem\n\n"
	echo "echo ~E0035RTC----------------FAILBML~^! > /dev/printer" >> helloworld
	buzzer_failure
	fi	
	
;;


####################   Ethernet   #############################

11) 
	echo -e "\n************************* Checking Ethernet Connection ****************************"
	eth=`cat /sys/class/net/eth0/carrier`
	sleep 2
	while [ "$eth" = "0" ]
	do
	eth=`cat /sys/class/net/eth0/carrier`
	if [ "$eth" = "0" ]
	then
	echo -e "\ncheck ethernet cable"
	fi
	echo "To test next module PRESS z"
	read -t 5 ethernet
	if [ "$ethernet" = "z" ] || [ "$ethernet" = "Z" ]
	then	
	break;
	fi
	done
	
	sleep 1
	echo -e "\nEthernet connectivity"
	cat /sys/class/net/eth0/operstate
	echo -e "\n"
	eth_connectivity=`cat /sys/class/net/eth0/operstate`
	if [ "$eth_connectivity" = "up" ]
	then
	sleep 2	
	ping -c 5 8.8.8.8
	if [ "$?" = "0" ]
	then
	
	echo -e "\n"
	echo "####################################################"
	echo "##############   Ethernet - Pass      ##############"
	echo "####################################################"
	echo -e "\n"
	echo "echo ~E0034ETHERNET-----------PASSBML^!>/dev/printer" >> helloworld
	buzzer_success
	else
	echo -e "\n"
	echo "####################################################"
	echo "##############   Ethernet - Fail      ##############"
	echo "####################################################"
	echo -e "\n"
	echo "echo ~E0034ETHERNET-----------FAILBML^!>/dev/printer" >> helloworld
	buzzer_failure
	fi
fi

;;


####################   RFID   #############################

12)

	usb_hub_enable
	sleep 1
	echo 1 > /sys/class/gpio/gpio$RFID_POWER/value
#	echo 0 > /sys/class/gpio/gpio245/value
	sleep 2
	echo -e "\n***************************** MODULE PRESENCE *******************************\n"	
	rfid=`nfc-list | grep  pn532_uart | awk '{print $8}'`

	if [ "$rfid" = "opened" ]
	then
	echo -e "\nPlease place the card within 5 sec\n"
	sleep 5
	UID=`nfc-list | grep UID | awk '{print $3 $4 $5 $6}'`
#	rfid_card=`nfc-list | grep ISO | awk '{print $2}'`	
#	if [ "$rfid_card" = "ISO14443A" ]
	if [ ]
	then	
	echo "UID - $UID"

	else
	echo -e "\n<<<<<<<<<   Card Not detected   >>>>>>>>>\n"
	fi

	echo "echo ~E0034RFID---------------PASSBML^!>/dev/printer" >> helloworld
	buzzer_success
	tested_ok
	else
	module_not_found
	echo "echo ~E0034RFID---------------FAILBML^!>/dev/printer" >> helloworld
	buzzer_failure
	fi
;;


####################   Sam Card Reader   #############################

13)

	sam_module="/dev/sc0"
	if [ -e "$sam_module" ]
	then
	touch card	
	sleep 2
	echo -e "\nPlease Insert the SAM card with in 5sec..\n "
	/opt/os/sc | grep ATR > card &
	sleep 5
	killall sc
	cat card
	sam_card=`ls -l | grep card | awk '{print $5}'`
	rm card
	if [ "$sam_card" = "0" ]
	then
	echo -e "\n<<<<<<<<<   Card Not detected   >>>>>>>>>\n"
	echo "echo ~E0034SAM----------------PASSBML^!>/dev/printer" >> helloworld
	buzzer_success
	tested_ok
	else
	echo "echo ~E0034SAM----------------PASSBML^!>/dev/printer" >> helloworld
	buzzer_success
	tested_ok
	fi
	else
	module_not_found
	echo "echo ~E0034SAM----------------FAILBML^!>/dev/printer" >> helloworld
	buzzer_failure
	fi
;;


####################   Smart Card Reader   #############################

14)

	usb_hub_enable
	sleep 2
	echo -e "\n----------------USB hub--------------------\n"
	lsusb | grep Gemplus	
	smart_module=`lsusb | grep Gemplus | awk '{print $7}'`
	smart_module=`echo ${smart_module:0:7}`
	if [ "$smart_module" = "Gemplus" ]
	then
	touch card	
	sleep 2
	echo -e "\nPlease Insert the SMART card with in 5sec..\n "
	pcscd -d -f | grep ATR > card &
	sleep 5
	killall pcscd
	cat card
	smart_card=`ls -l | grep card | awk '{print $5}'`
	rm card
	if [ "$smart_card" = "0" ]
	then
	echo -e "\n<<<<<<<<<   Card Not detected   >>>>>>>>>\n"
	echo "echo ~E0034SMART--------------PASSBML^!>/dev/printer" >> helloworld
	buzzer_success
	tested_ok
	else
	echo "echo ~E0034SMART--------------PASSBML^!>/dev/printer" >> helloworld
	buzzer_success
	tested_ok
	fi
	else
	module_not_found
	echo "echo ~E0034SMART--------------FAILBML^!>/dev/printer" >> helloworld
	buzzer_failure
	fi

;;


####################   Camera   #############################

15)

	echo 1 > /sys/class/gpio/gpio$FUTURE_USE/value
	sleep 2
	echo -e "\n---------USB modules------------\n"
	lsusb | grep Z-Star
	
	camerafile="/dev/video0"
	if [ -e "$camerafile" ]
	then
	killall TestReport
	./Camera -qws 2>/dev/null &
	sleep 10
	echo "echo ~E0034CAMERA-------------PASSBML^!>/dev/printer" >> helloworld
	killall Camera
	./TestReport -qws &
	buzzer_success
	tested_ok
	else
	module_not_found
	echo "echo ~E0034CAMERA-------------FAILBML^!>/dev/printer" >> helloworld
	buzzer_failure
	fi
;;


####################   Audio   #############################

16)

	usb_hub_enable
	echo 1 > /sys/class/gpio/gpio$AUDIO_POWER/value
	echo 1 > /sys/class/gpio/gpio$CAMERA_SWITCH/value
	sleep 2
	echo -e "\n---------USB modules------------\n"
	lsusb | grep C-Media
	
	audiofile="/dev/snd/pcmC0D0c"
	if [ -e "$audiofile" ]
	then
	exit=1
	while [ "$exit" = "1" ]
	do 
	echo -e "\nPlayer Details\n" 
	echo "1 - Record"
	echo "2 - Play recorded audio"
	echo "3 - Play default "
	echo -e "4 - Exit\n"
	read -p "Enter the audio code : " audio
	amixer set PCM 90%
	amixer set Mic capture 70%
	if [ "$audio" = "4" ]
	then
	exit=5
	killall play;killall rec
	echo 0 > /sys/class/gpio/gpio$AUDIO_POWER/value
	echo 0 > /sys/class/gpio/gpio$CAMERA_SWITCH/value
	sleep 2
	fi
	if [ "$audio" = "3" ]
	then
	play /usr/share/audio/test.mp3 2>/dev/null &
	fi
	if [ "$audio" = "2" ]
	then
	rec /tmp/sample.wav
	fi
	if [ "$audio" = "1" ]
	then
	echo -e "\n\n--------------   Recording   ------------------\n\n"
	play /tmp/sample.wav
	fi	
	done
	echo -e "\n\n"
	read -p "Testing Verification PASS or FAIL [p/f] : " verification

	if [ "$verification" = "p" ] || [ "$verification" = "P" ]
	then
	echo "echo ~E0035AUDIO--------------PASSBML~^! > /dev/printer" >> helloworld
	buzzer_success
	tested_ok
	else
	echo "echo ~E0035AUDIO--------------FAILBML~^! > /dev/printer" >> helloworld
	buzzer_failure
	fi

	else
	module_not_found
	echo "echo ~E0035AUDIO--------------FAILBML~^! > /dev/printer" >> helloworld
	buzzer_failure
	fi	

;;


####################   Keypad   #############################

17)

	keypad_module=`cat /sys/bus/i2c/devices/1-0034/modalias`
	if [ "$keypad_module" = "i2c:tca8418" ]
	then
	if [ -e "/dev/input/event1" ]
	then
	touch keypad_exit
	killall TestReport
	./KeyEvent -qws &
	sleep 2
	key_size=`ls -l | grep keypad_exit | awk '{print $5}'`

	while [ "$key_size" = "0" ]
	do
	key_size=`ls -l | grep keypad_exit | awk '{print $5}'`
	sleep 1
	done
	rm keypad_exit
	killall KeyEvent
	./TestReport -qws &
	echo -e "\n\n"
	read -p "Testing Verification PASS or FAIL [p/f] : " verification

	if [ "$verification" = "p" ] || [ "$verification" = "P" ]
	then
	echo "echo ~E0035Keypad-------------PASSBML~^! > /dev/printer" >> helloworld
	buzzer_success
	tested_ok
	else
	echo "echo ~E0035Keypad-------------FAILBML~^! > /dev/printer" >> helloworld
	buzzer_failure
	fi
	fi
	else
	module_not_found
	fi

;;


####################   Fingure Print   #############################

18)

	usb_hub_enable
	echo 1 > /sys/class/gpio/gpio$FP_POWER/value
	sleep 1
	echo -e "\n----------------USB hub--------------------\n"	
	lsusb | grep Sagem
	fp_module=`lsusb | grep Sagem | awk '{print $7}'`
	if [ "$fp_module" = "Sagem" ]
	then
	echo -e "\n<<<<<<<<<<<<   Module Present   >>>>>>>>>>>>>"
	echo -e "\n<<<<<<<<<<<<<   Fingure Test   >>>>>>>>>>>>>>> \n"
	echo -e "\n\n---------Test Capture(8) and Verify(9) --------\n\n"
	sleep 2	
	./MSO_Sample	
	echo -e "\n\n"
	read -p "Testing Verification PASS or FAIL [p/f] : " verification

	if [ "$verification" = "p" ] || [ "$verification" = "P" ]
	then
	echo "echo ~E0035Fingure_print------PASSBML~^! > /dev/printer" >> helloworld
	buzzer_success
	tested_ok
	else
	echo "echo ~E0035Fingure_print------FAILBML~^! > /dev/printer" >> helloworld
	buzzer_failure
	fi	
	else
	module_not_found
	echo "echo ~E0035Fingure_print------FAILBML~^! > /dev/printer" >> helloworld
	buzzer_failure
	fi
;;


####################   Wifi   #############################

19)
	
	echo -e "\n*************   Ethernet Status   *************\n"
	cat /sys/class/net/eth0/carrier
	cat /sys/class/net/eth0/operstate
	echo -e "\n+++++++++++++   Enabling wifi   ++++++++++++++++\n"	
	echo 1 > /sys/class/gpio/gpio$WIFI_POWER/value
	ifconfig eth0 down
	sleep 1
	ifconfig wlan0 192.168.0.171
	sleep 1
	iwconfig wlan0 essid "Virus"
	sleep 1
	route add default gw 192.168.0.121
	sleep 1
	ifconfig wlan0 up
	sleep 1
	echo -e "\n\n"	c program to get gateway ip
	ping -c 5 192.168.0.121
	if [ "$?" = "0" ]
	then
	
	echo -e "\n"
	echo "####################################################"
	echo "################   wifi - Pass      ################"
	echo "####################################################"
	echo -e "\n"
	echo "echo ~E0034wifi---------------PASSBML^!>/dev/printer" >> helloworld
	buzzer_success
	echo 0 > /sys/class/gpio/gpio$WIFI_POWER/value
	else
	echo -e "\n"
	echo "####################################################"
	echo "################   wifi - Fail      ################"
	echo "####################################################"
	echo -e "\n"
	echo "echo ~E0034wifi---------------FAILBML^!>/dev/printer" >> helloworld
	buzzer_failure
	echo 0 > /sys/class/gpio/gpio$WIFI_POWER/value
	fi

;;


####################   Bluetooth   #############################

20)
	
	killall rfcomm
#	echo 1 > /sys/class/gpio/gpio248/value
	echo -e "\n+++++++++++++   Configuring Bluetooth   ++++++++++++++++\n"
	usb_hub_enable
	sleep 3
	bluetoothd
	sleep 1
	rfcomm listen hci0 &
	echo -e "\n+++++++++++++   Connect the bluetooth with in 5sec   ++++++++++++++++\n"
	sleep 15	
	if [ -e "/dev/rfcomm0" ]
	then
	while [ 1 ]
	do
	read input < /dev/rfcomm0
	echo "$input" > /dev/tty0
	if [ "$input" = "a" ]
	then
	sh /usr/share/scripts/Buzzer 1
	fi	
	if [ "$input" = "b" ]
	then
	sh /usr/share/scripts/Buzzer 2
	fi	
	if [ "$input" = "c" ]
	then
	sh /usr/share/scripts/Buzzer 3
	fi	
	if [ "$input" = "d" ]
	then
	sh /usr/share/scripts/Buzzer 4
	fi		
	if [ "$input" = "exit" ]
	then
	echo -e "\n"
	echo "####################################################"
	echo "#############   BLUETOOTH - Pass      ##############"
	echo "####################################################"
	echo -e "\n"
	echo "echo ~E0034Bluetooth----------PASSBML^!>/dev/printer" >> helloworld
	buzzer_success
	#echo 0 > /sys/class/gpio/gpio248/value
	break;
	fi	
	done

	else
	echo -e "\n"
	echo "####################################################"
	echo "#############   BLUETOOTH - Fail      ##############"
	echo "####################################################"
	echo -e "\n"
	echo "echo ~E0034Bluetooth----------FAILBML^!>/dev/printer" >> helloworld
	buzzer_failure
#	echo 0 > /sys/class/gpio/gpio248/value
	fi
	sleep 2
	killall rfcomm

;;


####################   Printer   #############################

21)

	count=0
	total=0
	echo -e "\n**********************PRINTING********************************\n"

	printer_Tested_by=`cat helloworld | grep "Tested" | awk '{print $3}'`
	if [ "$printer_Tested_by" = "Tested" ]
	then
	report_tested_by=`cat helloworld | grep "Tested" | awk '{print $6}'`
	echo -e "\nReported already tested by - $report_tested_by\n"

	sh helloworld
	echo ~R0070>/dev/printer
	buzzer_failure
	buzzer_failure

	else
	
	date=`hwclock -r /dev/rtc1 | awk '{print $3}'`
	month=`hwclock -r /dev/rtc1 | awk '{print $2}'`
	year=`hwclock -r /dev/rtc1 | awk '{print $5}'`
	time=`hwclock -r /dev/rtc1 | awk '{print $4}'`
	month_count=`echo ${#month}`
	date_ref=27
	date_total=`expr $month_count + $date_ref`
	echo "Hardware clock details"	
	echo -e "\nDATE - $date $month $year"
	echo -e "TIME - $time"
	echo "echo ~E00$date_total Date - $date $month $year BML~^! > /dev/printer" >> helloworld
	echo "echo ~E0029 Time - $time BML~^! > /dev/printer" >> helloworld
	read -p "Tested By - " name
	echo -e "\nTested By - $name"
	ref=25
	count=`echo ${#name}`
	total=`expr $count + $ref`
	echo "echo ~E00$total Tested By - $name BML~^! > /dev/printer" >> helloworld
	sh helloworld
	echo ~R0070>/dev/printer
	buzzer_failure
	buzzer_failure
	fi
;;

0)

exit=5
break
;;

	
esac

fi

done
